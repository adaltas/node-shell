import { shell } from "../../lib/index.js";

describe("options.default", function () {
  describe("without commands", function () {
    it("set value if not defined", function () {
      const app = shell({
        options: {
          my_argument: {
            default: "default value",
          },
        },
      });
      app.parse([]).should.eql({
        my_argument: "default value",
      });
      app.compile({}).should.eql(["--my_argument", "default value"]);
    });
  });

  describe("with commands", function () {
    it("set value if not defined, flatten mode", function () {
      const app = shell({
        commands: {
          my: {
            commands: {
              command: {
                options: {
                  my_argument: {
                    default: "default value",
                  },
                },
              },
            },
          },
        },
      });
      app.parse(["my", "command"]).should.eql({
        command: ["my", "command"],
        my_argument: "default value",
      });
      app
        .compile({ command: ["my", "command"] })
        .should.eql(["my", "command", "--my_argument", "default value"]);
    });

    it("set value if not defined, extended mode", function () {
      // Note, the way default option is implemented shall not
      // have any impact on flatten and extended mode
      const app = shell({
        extended: true,
        commands: {
          my: {
            commands: {
              command: {
                options: {
                  my_argument: {
                    default: "default value",
                  },
                },
              },
            },
          },
        },
      });
      app
        .parse(["my", "command"])
        .should.eql([
          {},
          { command: "my" },
          { command: "command", my_argument: "default value" },
        ]);
      app
        .compile([{}, { command: "my" }, { command: "command" }])
        .should.eql(["my", "command", "--my_argument", "default value"]);
    });

    it("preserve global option", function () {
      const app = shell({
        commands: {
          my_command: {
            options: {
              command_argument: {
                default: "command value",
              },
            },
          },
        },
        options: {
          global_argument: {
            default: "global value",
          },
        },
      });
      app.parse(["my_command"]).should.eql({
        command: ["my_command"],
        global_argument: "global value",
        command_argument: "command value",
      });
      app
        .compile({ command: ["my_command"] })
        .should.eql([
          "--global_argument",
          "global value",
          "my_command",
          "--command_argument",
          "command value",
        ]);
    });
  });
});
