import { shell } from "../../lib/index.js";

describe("options.strict", function () {
  it("throw error for an undefined option", function () {
    const app = shell({ strict: true });
    (function () {
      app.parse(["--myoption", "my", "--command"]);
    }).should.throw(
      "Invalid Argument: the argument --myoption is not a valid option",
    );
    (function () {
      app.compile({
        myoption: true,
      });
    }).should.throw(
      "Invalid Parameter: the property --myoption is not a registered argument",
    );
  });

  it("throw error for an undefined argument inside an command", function () {
    const app = shell({
      strict: true,
      commands: {
        mycommand: {},
      },
    });
    (function () {
      app.parse(["mycommand", "--myoption", "my", "--command"]);
    }).should.throw(
      "Invalid Argument: the argument --myoption is not a valid option",
    );
    (function () {
      app.compile({
        command: "mycommand",
        myoption: true,
      });
    }).should.throw(
      "Invalid Parameter: the property --myoption is not a registered argument",
    );
  });
});
