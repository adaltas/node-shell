import { Writable } from "node:stream";
import { shell } from "../../lib/index.js";

describe("handler.stdout", function () {
  it("pass custom writable stream", function () {
    const app = shell({
      router: {
        stdout: new Writable({
          write: function (data) {
            Buffer.isBuffer(data).should.be.true();
            data.toString().should.eql("hello");
          },
        }),
      },
      handler: function ({ stdout }) {
        stdout.write("hello");
      },
    });
    app.route([]);
  });
});
