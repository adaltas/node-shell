import { shell } from "../../lib/index.js";

describe("help/help.api", function () {
  it("is empty", function () {
    shell({
      commands: {
        start: {},
      },
    })
      .help()
      .should.match(/myapp - No description yet/);
  });

  it("command string", function () {
    shell({
      commands: {
        server: {
          commands: {
            start: {},
          },
        },
      },
    })
      .help("server start")
      .should.match(/myapp server start - No description yet/);
  });

  it("command array", function () {
    shell({
      commands: {
        start: {},
      },
    })
      .help(["start"])
      .should.match(/myapp start - No description yet/);
  });

  it("throw error if shell match an undefined command", function () {
    (function () {
      shell({
        commands: {
          start: {},
        },
      }).help(["start", "sth"]);
    }).should.throw(
      'Invalid Command: argument "start sth" is not a valid command',
    );
  });
});
