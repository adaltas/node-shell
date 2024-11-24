import fs from "node:fs/promises";
import os from "node:os";
import { Writable } from "node:stream";
import { shell } from "../../lib/index.js";

const writer = (callback) => {
  const chunks = [];
  return new Writable({
    write: function (chunk, encoding, callback) {
      chunks.push(chunk.toString());
      callback();
    },
  }).on("finish", function () {
    callback(chunks.join(""));
  });
};

describe("router.handler.error", function () {
  describe("thrown error in async function handler", function () {
    it("value", function () {
      (function () {
        shell({
          handler: function () {
            throw Error("catch me");
          },
          options: {
            my_argument: {},
          },
          router: {
            stderr: writer(function () {}),
          },
        }).route(["--my_argument", "my value"]);
      }).should.throw("catch me");
    });

    it("stderr", async function () {
      const output = await new Promise((resolve) => {
        try {
          shell({
            handler: function () {
              throw Error("catch me");
            },
            options: {
              my_argument: {},
            },
            router: {
              stderr: writer(resolve),
              stderr_end: true,
            },
          }).route(["--my_argument", "my value"]);
        } catch (e) {
          e; // do nothing
        }
      });
      output.should.containEql(
        'Command failed to execute, message is: "catch me"',
      );
    });
  });

  describe("rejected error in async function handler", function () {
    it("value", function () {
      return shell({
        handler: async function () {
          await Promise.reject(Error("catch me"));
        },
        options: {
          my_argument: {},
        },
        router: {
          stderr: writer(function () {}),
        },
      })
        .route(["--my_argument", "my value"])
        .should.be.rejectedWith("catch me");
    });

    it("stderr", async function () {
      const output = await new Promise((resolve) => {
        shell({
          handler: async function () {
            await Promise.reject(Error("catch me"));
          },
          options: { my_argument: {} },
          router: {
            stderr: writer(resolve),
            stderr_end: true,
          },
        }).route(["--my_argument", "my value"]);
      });
      output.should.containEql(
        "Command failed to execute, message is: catch me",
      );
    });
  });

  describe("thrown error from imported sync handler", function () {
    it("stderr", async function () {
      const handler = `${os.tmpdir()}/router_load_thrown_error.js`;
      try {
        await fs.writeFile(
          handler,
          'module.exports = () => { throw Error("catch me") }',
        );
        const output = await new Promise((resolve) => {
          shell({
            handler: handler,
            options: { my_argument: {} },
            router: {
              stderr: writer(resolve),
              stderr_end: true,
            },
          }).route(["--my_argument", "my value"]);
        });
        output.should.containEql("Fail to load route. Message is: catch me");
      } finally {
        await fs.unlink(handler);
      }
    });
  });

  describe("rejected error from imported async sync handler", function () {
    it("stderr", async function () {
      const handler = `${os.tmpdir()}/router_load_reject_error.js`;
      try {
        await fs.writeFile(
          handler,
          'module.exports = async () => await Promise.reject(Error("catch me"))',
        );
        const output = await new Promise((resolve) => {
          shell({
            handler: handler,
            options: { my_argument: {} },
            router: {
              stderr: writer(resolve),
              stderr_end: true,
            },
          }).route(["--my_argument", "my value"]);
        });
        output.should.containEql("Fail to load route. Message is: catch me");
      } finally {
        await fs.unlink(handler);
      }
    });
  });

  describe("thrown error from invalid imported module", function () {
    it("stderr", async function () {
      const handler = `${os.tmpdir()}/router_load_handler_invalid.js`;
      try {
        await fs.writeFile(handler, "invalid module");
        const output = await new Promise((resolve) => {
          shell({
            handler: handler,
            options: { my_argument: {} },
            router: {
              stderr: writer(resolve),
              stderr_end: true,
            },
          }).route(["--my_argument", "my value"]);
        });
        output.should.containEql(
          `Fail to load module "${handler}", message is: Unexpected identifier 'module'`,
        );
      } finally {
        await fs.unlink(handler);
      }
    });
  });
});
