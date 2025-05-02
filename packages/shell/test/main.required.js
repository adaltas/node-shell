import { shell } from "../lib/index.js";

describe("main.required", function () {
  it("optional by default", function () {
    const app = shell({
      commands: {
        my_command: {
          main: {
            name: "my_argument",
          },
        },
      },
    });
    app.parse(["my_command"]).should.eql({
      command: ["my_command"],
      my_argument: [],
    });
    app
      .compile({
        command: ["my_command"],
      })
      .should.eql(["my_command"]);
  });

  it("honors required true if value is provided", function () {
    const app = shell({
      commands: {
        my_command: {
          main: {
            name: "my_argument",
            required: true,
          },
        },
      },
    });
    app.parse(["my_command", "my --value"]).should.eql({
      command: ["my_command"],
      my_argument: ["my --value"],
    });
    app
      .compile({
        command: ["my_command"],
        my_argument: ["my --value"],
      })
      .should.eql(["my_command", "my --value"]);
  });

  it("honors required true if no value provided", function () {
    const app = shell({
      commands: {
        my_command: {
          main: {
            name: "my_argument",
            required: true,
          },
        },
      },
    });
    (function () {
      app.parse(["my_command"]);
    }).should.throw(
      'Required Main Argument: no suitable arguments for "my_argument"',
    );
    (function () {
      app.compile({
        command: ["my_command"],
      });
    }).should.throw(
      'Required Main Parameter: no suitable arguments for "my_argument"',
    );
  });

  describe("function", function () {
    it("receive config and command", function () {
      const app = shell({
        commands: {
          my_command: {
            main: {
              name: "my_argument",
              required: function ({ config, command }) {
                config.name.should.eql("my_command");
                config.command.should.eql(["my_command"]);
                command.should.eql("my_command");
                return false;
              },
            },
          },
        },
      });
      app.parse(["my_command"]);
    });

    it("return `true`", function () {
      const app = shell({
        commands: {
          my_command: {
            main: {
              name: "my_argument",
              required: function () {
                return true;
              },
            },
          },
        },
      });
      // Invalid, no argument is provided
      (function () {
        app.parse(["my_command"]);
      }).should.throw(
        'Required Main Argument: no suitable arguments for "my_argument"',
      );
      (function () {
        app.compile({
          command: ["my_command"],
        });
      }).should.throw(
        'Required Main Parameter: no suitable arguments for "my_argument"',
      );
    });
  });
});
