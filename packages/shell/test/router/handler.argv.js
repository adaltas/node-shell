import { shell } from "../../lib/index.js";

describe("handler.argv", function () {
  it("no argument", function () {
    const app = shell({
      handler: ({ argv }) => {
        argv.should.eql([]);
      },
    });
    app.route([]);
  });

  it("with arguments", function () {
    shell({
      handler: ({ argv }) => {
        argv.should.eql(["--port", 80]);
      },
    }).route(["--port", 80]);
  });
});
