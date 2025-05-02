import { shell } from "../lib/index.js";

describe("main", function () {
  describe("invalid", function () {
    it("command extra arguments without main", function () {
      // Command with no option
      (function () {
        shell({
          commands: {
            mycommand: {},
          },
        }).parse(["mycommand", "mymain"]);
      }).should.throw(
        'Invalid Argument: fail to interpret all arguments "mymain"',
      );

      // Command with one option
      (function () {
        shell({
          commands: {
            mycommand: {
              options: {
                arg: {},
              },
            },
          },
        }).parse(["mycommand", "--arg", "myarg", "mymain"]);
      }).should.throw(
        'Invalid Argument: fail to interpret all arguments "mymain"',
      );
    });
  });

  describe("without command", function () {
    it("workout any main arguments", function () {
      const app = shell({
        main: {
          name: "leftover",
        },
      });
      app.parse([]).should.eql({
        leftover: [],
      });
      app.compile({}).should.eql([]);
      app
        .compile({
          leftover: [],
        })
        .should.eql([]);
    });

    it("preserve space in main arguments", function () {
      const app = shell({
        main: {
          name: "leftover",
        },
      });
      app.parse(["my value"]).should.eql({
        leftover: ["my value"],
      });
      app
        .compile({
          leftover: ["my value"],
        })
        .should.eql(["my value"]);
    });

    it("handle multiple main arguments", function () {
      const app = shell({
        main: {
          name: "leftover",
        },
      });
      app.parse(["my", "value"]).should.eql({
        leftover: ["my", "value"],
      });
      app
        .compile({
          leftover: ["my", "value"],
        })
        .should.eql(["my", "value"]);
    });
  });

  describe("with command", function () {
    it("accept an optional main and no option", function () {
      const app = shell({
        commands: {
          start: {
            main: {
              name: "leftover",
            },
          },
        },
      });
      app.parse(["start", "my", "value true"]).should.eql({
        command: ["start"],
        leftover: ["my", "value true"],
      });
      app
        .compile({
          command: ["start"],
          leftover: ["my", "value true"],
        })
        .should.eql(["start", "my", "value true"]);
    });

    it("may follow command without any option", function () {
      const app = shell({
        commands: {
          mycommand: {
            main: {
              name: "leftover",
              required: true,
            },
          },
        },
      });
      app.parse(["mycommand", "my value"]).should.eql({
        command: ["mycommand"],
        leftover: ["my value"],
      });
      app
        .compile({
          command: ["mycommand"],
          leftover: ["my value"],
        })
        .should.eql(["mycommand", "my value"]);
    });
  });
});
