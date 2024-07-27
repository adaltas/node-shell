import fs from "node:fs/promises";
import os from "node:os";
import dedent from "dedent";
import { shell } from "../lib/index.js";

describe("api.load", function () {
  it("load relative to require.main", async function () {
    const cwd = process.cwd();
    process.chdir(os.tmpdir());
    await fs.writeFile(
      `${os.tmpdir()}/relative_module.coffee`,
      dedent`
    export default (params) -> params
    `,
    );
    const mod = await shell().load(`${os.tmpdir()}/relative_module.coffee`);
    mod("my value").should.eql("my value");
    process.chdir(cwd);
    await fs.unlink(`${os.tmpdir()}/relative_module.coffee`);
  });

  it("load is not a string", async function () {
    await shell({
      name: "start",
    })
      .load({ name: "something" })
      .should.be.rejectedWith(
        'Invalid Load Argument: load is expecting string, got {"name":"something"}',
      );
  });
});
