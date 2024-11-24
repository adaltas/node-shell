import fs from "node:fs/promises";
import os from "node:os";
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

describe("router.load", function () {
  it("application route", async function () {
    const mod = `${os.tmpdir()}/node_params.coffee`;
    await fs.writeFile(
      `${mod}`,
      "export default ({params}) -> params.my_argument",
    );
    await shell({
      handler: mod,
      options: { my_argument: {} },
    })
      .route(["--my_argument", "my value"])
      .should.be.resolvedWith("my value");
    await fs.unlink(`${mod}`);
  });

  it("command route", async function () {
    const mod = `${os.tmpdir()}/node_params.coffee`;
    await fs.writeFile(
      `${mod}`,
      "export default ({params}) -> params.my_argument",
    );
    await shell({
      commands: {
        my_command: {
          handler: mod,
          options: { my_argument: {} },
        },
      },
    })
      .route(["my_command", "--my_argument", "my value"])
      .should.be.resolvedWith("my value");
    await fs.unlink(`${mod}`);
  });

  it("error to load route", async function () {
    const mod = `${os.tmpdir()}/router_load_handler_invalid.coffee`;
    await fs.writeFile(`${mod}`, "Oh no, this is so invalid");
    await shell({
      handler: mod,
      options: { my_argument: {} },
      router: {
        stderr: writer(function (output) {
          output.should.containEql(
            `Fail to load module "${mod}", message is: Oh is not defined.`,
          );
        }),
        stderr_end: true,
      },
    }).route(["--my_argument", "my value"]);
    await fs.unlink(`${mod}`);
  });
});
