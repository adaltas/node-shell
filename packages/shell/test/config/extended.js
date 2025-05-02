import { shell } from "../../lib/index.js";

describe("config.extended", function () {
  describe("validation", function () {
    it("must be a boolean", function () {
      // Command with no option
      shell({ extended: true });
      shell({ extended: false });
      (function () {
        shell({ extended: "sth" });
      }).should.throw(
        'Invalid Configuration: extended must be a boolean, got "sth"',
      );
      (function () {
        shell({ extended: {} });
      }).should.throw(
        "Invalid Configuration: extended must be a boolean, got {}",
      );
    });

    it("cannot be declared inside a command", function () {
      (function () {
        shell({
          commands: {
            mycmd: {
              extended: true,
            },
          },
        });
      }).should.throw(
        "Invalid Command Configuration: extended property cannot be declared inside a command",
      );
    });
  });

  describe("main", function () {
    it("application get leftover", function () {
      const app = shell({
        extended: true,
        main: {
          name: "leftover",
        },
      });
      app.parse(["my value"]).should.eql([
        {
          leftover: ["my value"],
        },
      ]);
      app.parse([]).should.eql([
        {
          leftover: [],
        },
      ]);
      app
        .compile([
          {
            leftover: ["my value"],
          },
        ])
        .should.eql(["my value"]);
      app.compile([{}]).should.eql([]);
    });

    it("application with configured commands get leftover", function () {
      const app = shell({
        extended: true,
        main: {
          name: "leftover",
        },
        commands: {
          subcommand: {},
        },
      });
      app.parse(["my --command"]).should.eql([
        {
          leftover: ["my --command"],
        },
      ]);
      app
        .compile([
          {
            leftover: ["my --command"],
          },
        ])
        .should.eql(["my --command"]);
    });
  });
});
