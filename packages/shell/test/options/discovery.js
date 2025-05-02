import { shell } from "../../lib/index.js";

describe("options.discovery", function () {
  it("discover unregistered options", function () {
    const app = shell();
    app.parse(["--myoption", "my value"]).should.eql({
      myoption: "my value",
    });
    app
      .compile({
        myoption: "my value",
      })
      .should.eql(["--myoption", "my value"]);
  });

  it("discover unregistered options in command", function () {
    const app = shell({ commands: { mycommand: {} } });
    app.parse(["mycommand", "--myoption", "my value"]).should.eql({
      command: ["mycommand"],
      myoption: "my value",
    });
    app
      .compile({
        command: ["mycommand"],
        myoption: "my value",
      })
      .should.eql(["mycommand", "--myoption", "my value"]);
  });

  it("deal with boolean", function () {
    const app = shell();
    app.parse(["--myoption"]).should.eql({
      myoption: true,
    });
    app
      .compile({
        myoption: true,
      })
      .should.eql(["--myoption"]);
  });
});
