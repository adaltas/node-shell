import { shell } from "../../lib/index.js";

describe("help/helping.api", function () {
  it("flatten expect an object", function () {
    (function () {
      shell().helping("invalid");
    }).should.throw(
      'Invalid Arguments: `helping` expect a params object as first argument in flatten mode, got "invalid"',
    );
  });

  it("extended expect an array of objects", function () {
    (function () {
      shell({
        extended: true,
      }).helping(["invalid"]);
    }).should.throw(
      'Invalid Arguments: `helping` expect a params array with literal objects as first argument in extended mode, got ["invalid"]',
    );
  });

  it("ensure command is an array in flatten mode", function () {
    (function () {
      shell({
        commands: {
          start: {
            commands: {
              server: {},
            },
          },
        },
      }).helping({
        command: "help",
        name: "start",
      });
    }).should.throw(
      'Invalid Arguments: parameter "command" must be an array in flatten mode, got "help"',
    );
  });
});
