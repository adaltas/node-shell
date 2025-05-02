import { shell } from "../../lib/index.js";

describe("options.shortcut", function () {
  it("throw error for an undeclared shortcut", function () {
    // Test a boolean (no value) argument
    const app = shell();
    (function () {
      app.parse(["-c"]);
    }).should.throw(
      'Invalid Shortcut Argument: the "-c" argument is not a valid option',
    );
    (function () {
      app.parse(["-c", "a value"]);
    }).should.throw(
      'Invalid Shortcut Argument: the "-c" argument is not a valid option',
    );
  });

  it("throw error for an undeclared shortcut in command", function () {
    // Test a boolean (no value) argument
    const app = shell({
      commands: {
        server: {
          commands: {
            start: {},
          },
        },
      },
    });
    (function () {
      app.parse(["server", "start", "-c"]);
    }).should.throw(
      'Invalid Shortcut Argument: the "-c" argument is not a valid option in command "server start"',
    );
    (function () {
      app.parse(["server", "start", "-c", "a value"]);
    }).should.throw(
      'Invalid Shortcut Argument: the "-c" argument is not a valid option in command "server start"',
    );
  });

  it("handle help shortcut", function () {
    // Test a boolean (no value) argument
    shell().parse(["-h"]).help.should.be.true;
  });
});
