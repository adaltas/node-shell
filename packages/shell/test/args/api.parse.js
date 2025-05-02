import { shell } from "../../lib/index.js";

describe("api.parse", function () {
  it("does not alter input arguments", function () {
    const app = shell({
      commands: {
        start: {
          options: {
            my_option: {
              shortcut: "w",
            },
          },
        },
      },
    });
    const argv = ["start", "--my_option", "my value"];
    app.parse(argv);
    argv.should.eql(["start", "--my_option", "my value"]);
  });

  it("catch argument without a value because end of argv", function () {
    const app = shell({
      commands: {
        start: {
          options: {
            an_int: {
              type: "integer",
            },
            a_string: {
              type: "string",
            },
            an_array: {
              type: "array",
            },
          },
        },
      },
    });
    (function () {
      app.parse(["start", "--an_int"]);
    }).should.throw('Invalid Option: no value found for option "an_int"');
    (function () {
      app.parse(["start", "--a_string"]);
    }).should.throw('Invalid Option: no value found for option "a_string"');
    (function () {
      app.parse(["start", "--an_array"]);
    }).should.throw('Invalid Option: no value found for option "an_array"');
  });

  it("catch argument without a value because next argv is a shortcut", function () {
    const app = shell({
      commands: {
        start: {
          options: {
            an_int: {
              type: "integer",
            },
            a_string: {
              type: "string",
            },
            an_array: {
              type: "array",
            },
            some: {
              type: "string",
            },
          },
        },
      },
    });
    (function () {
      app.parse(["start", "--an_int", "--some", "thing"]);
    }).should.throw('Invalid Option: no value found for option "an_int"');
    (function () {
      app.parse(["start", "--a_string", "--some", "thing"]);
    }).should.throw('Invalid Option: no value found for option "a_string"');
    (function () {
      app.parse(["start", "--an_array", "--some", "thing"]);
    }).should.throw('Invalid Option: no value found for option "an_array"');
  });
});
