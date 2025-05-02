import { shell } from "../../lib/index.js";

describe("config.options.api", function () {
  describe("list", function () {
    it("for application", function () {
      shell({
        options: {
          config: {},
        },
        commands: {
          server: {
            commands: {
              start: {},
            },
          },
        },
      })
        .config()
        .options.list()
        .should.eql(["config", "help"]);
    });

    it("for a command", function () {
      shell({
        options: {
          config: {},
        },
        commands: {
          app: {
            commands: {
              server: {
                options: {
                  host: {},
                  port: {},
                },
              },
            },
          },
        },
      })
        .config(["app", "server"])
        .options.list()
        .should.eql(["help", "host", "port"]);
    });
  });

  describe("get", function () {
    it("an option (2 styles)", function () {
      shell({
        options: {
          config: {},
        },
        commands: {
          server: {
            commands: {
              start: {},
            },
          },
        },
      })
        .config()
        .options("config")
        .get()
        .name.should.eql("config");
    });

    it("selected properties from option", function () {
      shell({
        options: {
          config: {},
        },
        commands: {
          server: {
            commands: {
              start: {},
            },
          },
        },
      })
        .config()
        .options("config")
        .set("description", "hello")
        .set("required", true)
        .get(["description", "required"])
        .should.eql({
          description: "hello",
          required: true,
        });
    });
  });

  describe("set", function () {
    it("an option in a command", function () {
      shell({
        options: {
          config: {},
        },
        commands: {
          server: {
            commands: {
              start: {},
            },
          },
        },
      })
        .config()
        .options("config")
        .set("description", "hello")
        .set("required", true)
        .get()
        .name.should.eql("config");
    });
  });

  describe("get_cascaded", function () {
    it("return the cascaded options", function () {
      shell({
        options: {
          opt_app: { cascade: true },
        },
        commands: {
          server: {
            options: {
              opt_cmd: { cascade: true },
            },
            commands: {
              start: {},
            },
          },
        },
      })
        .config(["server", "start"])
        .options.get_cascaded()
        .should.eql({
          help: {
            cascade: true,
            description: "Display help information",
            help: true,
            name: "help",
            shortcut: "h",
            type: "boolean",
          },
          opt_app: {
            cascade: true,
            name: "opt_app",
            type: "string",
          },
          opt_cmd: {
            cascade: true,
            name: "opt_cmd",
            type: "string",
          },
        });
    });
  });
});
