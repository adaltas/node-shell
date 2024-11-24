import { Writable } from "node:stream";
import { shell } from "../../lib/index.js";

function writer(callback) {
  const chunks = [];
  return new Writable({
    write: function (chunk, encoding, callback) {
      chunks.push(chunk.toString());
      callback();
    },
  }).on("finish", function () {
    callback(chunks.join(""));
  });
}

describe("router.hook", function () {
  it("shell:router:call validate context", function () {
    shell({
      handler: function () {},
    })
      .plugins.register({
        "shell:router:call": function (context, handler) {
          Object.keys(context)
            .sort()
            .should.eql([
              "args",
              "argv",
              "command",
              "error",
              "params",
              "stderr",
              "stderr_end",
              "stdin",
              "stdout",
              "stdout_end",
            ]);
          return handler;
        },
      })
      .route([]);
  });

  it("shell:router:call modify shell", function (next) {
    shell({
      handler: function ({ stdout }) {
        stdout.write("gotit");
        stdout.end();
      },
    })
      .plugins.register({
        hooks: {
          "shell:router:call": function (context, handler) {
            context.stdout = writer(function (data) {
              data.should.eql("gotit");
              next();
            });
            return handler;
          },
        },
      })
      .route([]);
  });
});
