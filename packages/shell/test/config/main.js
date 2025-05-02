import { shell } from "../../lib/index.js";

describe("config.main", function () {
  it("accept main as a string", function () {
    shell({
      main: "leftover",
    })
      .config()
      .get()
      .main.should.eql({
        name: "leftover",
      });
  });

  it("accept main in a command as a string", function () {
    shell({
      commands: {
        start: {
          main: "leftover",
        },
      },
    })
      .config("start")
      .get()
      .main.should.eql({
        name: "leftover",
      });
  });

  it("name must be null, object or string", function () {
    (function () {
      shell({
        // extended: true
        commands: {
          server: {
            main: true,
            handler: function () {},
          },
        },
        strict: true,
      });
    }).should.throw(
      [
        "Invalid Main Configuration:",
        "accepted values are string, null and object,",
        "got `true`",
      ].join(" "),
    );
  });

  it("name cannot equal command", function () {
    (function () {
      shell({
        // extended: true
        commands: {
          server: {
            main: "command",
            handler: function () {},
          },
        },
        strict: true,
      });
    }).should.throw(
      [
        "Conflicting Main Value:",
        "main name is conflicting with the command name,",
        'got `"command"`',
      ].join(" "),
    );
  });
});
