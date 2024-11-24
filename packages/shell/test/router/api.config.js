import { Readable, Writable } from "node:stream";
import { shell } from "../../lib/index.js";

describe("router.config.router", function () {
  describe("router", function () {
    it("accept string (eg stderr)", function () {
      shell({}).config().get().router.should.eql({
        error_message: true,
        error_stack: false,
        error_help: false,
        handler: "shell/routes/help",
        promise: false,
        stderr: process.stderr,
        stderr_end: false,
        stdin: process.stdin,
        stdout: process.stdout,
        stdout_end: false,
      });
    });

    it("pass custom readable and writable streams", function () {
      shell({
        router: {
          stderr: new Writable(),
          stdin: new Readable(),
          stdout: new Writable(),
        },
      })
        .config()
        .get()
        .router.should.match({
          handler: "shell/routes/help",
          promise: false,
          stderr: new Writable(),
          stderr_end: false,
          stdin: new Readable(),
          stdout: new Writable(),
          stdout_end: false,
        });
    });
  });

  describe("options", function () {
    it("auto generate the help options in application", function () {
      shell({})
        .config()
        .get()
        .options.should.eql({
          help: {
            cascade: true,
            description: "Display help information",
            help: true,
            name: "help",
            type: "boolean",
            shortcut: "h",
          },
        });
      shell({}).config().get().shortcuts.should.eql({
        h: "help",
      });
    });

    it("auto generate the help options in command with sub-command", function () {
      shell({
        commands: {
          server: {
            commands: {
              start: {},
            },
          },
        },
      })
        .config(["server"])
        .get()
        .options.should.eql({
          help: {
            cascade: true,
            description: "Display help information",
            help: true,
            name: "help",
            shortcut: "h",
            transient: true,
            type: "boolean",
          },
        });
    });
  });

  describe("commands", function () {
    it("overwrite command description", function () {
      shell({
        commands: {
          start: {
            options: { myopt: {} },
          },
          help: {
            description: "Overwrite description",
          },
        },
      })
        .config()
        .get()
        .commands.help.should.eql({
          name: "help",
          help: true,
          description: "Overwrite description",
          command: ["help"],
          main: {
            name: "name",
            description: "Help about a specific command",
          },
          handler: "shell/routes/help",
          strict: false,
          shortcuts: {},
          options: {},
          commands: {},
        });
    });

    it("does not conflict with default description", function () {
      shell({
        commands: {
          start: {},
          help: {},
        },
      })
        .config(["help"])
        .get()
        .description.should.eql("Display help information");
    });
  });
});
