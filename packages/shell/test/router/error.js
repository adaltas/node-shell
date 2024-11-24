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

describe("router.error", function () {
  describe("option", function () {
    it("application help", function () {
      return new Promise(function (resolve, reject) {
        shell({
          router: {
            stderr: writer(resolve),
            stderr_end: true,
          },
        })
          .route(["--help"])
          .catch(reject);
      }).then(function (output) {
        output.should.match(/myapp - No description yet/);
      });
    });

    it("command help", function () {
      return new Promise(function (resolve, reject) {
        shell({
          router: {
            stderr: writer(resolve),
            stderr_end: true,
          },
          commands: {
            server: {
              commands: {
                start: {},
              },
            },
          },
        })
          .route(["server", "--help"])
          .catch(reject);
      }).then(function (output) {
        output.should.match(
          /myapp server - No description yet for the server command/,
        );
      });
    });
  });

  describe("help command", function () {
    it("application help", function () {
      return new Promise(function (resolve, reject) {
        shell({
          router: {
            stderr: writer(resolve),
            stderr_end: true,
            error_help: true,
          },
        })
          .route([])
          .catch(reject);
      }).then(function (output) {
        output.should.containEql(
          'Missing Application Handler: a "handler" definition is required when no child command is defined',
        );
        output.should.containEql("myapp - No description yet");
      });
    });

    it("command help", function () {
      return new Promise(function (resolve, reject) {
        shell({
          router: {
            stderr: writer(resolve),
            stderr_end: true,
          },
          commands: {
            server: {
              commands: {
                start: {},
              },
            },
          },
        })
          .route(["help", "server"])
          .catch(reject);
      }).then(function (output) {
        output.should.match(
          /myapp server - No description yet for the server command/,
        );
      });
    });
  });

  describe("command", function () {
    it("command without route and with orphan print help", function () {
      return new Promise(function (resolve, reject) {
        shell({
          router: {
            stderr: writer(resolve),
            stderr_end: true,
          },
          commands: {
            server: {
              commands: {
                start: {
                  commands: {
                    sth: {},
                  },
                },
              },
            },
          },
        })
          .route(["server", "start"])
          .catch(reject);
      }).then(function (output) {
        output.should.not.match(
          /^\s+Missing Command Handler: a "handler" definition \["server","start"\] is required when no child command is defined/,
        );
        output.should.match(
          /^\s+myapp server start - No description yet for the start command/m,
        );
      });
    });

    it("print error message if leaf", async function () {
      const output = await new Promise(function (resolve, reject) {
        shell({
          router: {
            stderr: writer(resolve),
            stderr_end: true,
            error_help: true,
          },
          commands: {
            server: {
              commands: {
                start: {},
              },
            },
          },
        })
          .route(["server", "start"])
          .catch(reject);
      });
      output.should.containEql(
        'Missing Command Handler: a "handler" definition ["server","start"] is required when no child command is defined',
      );
      output.should.containEql(
        "myapp server start - No description yet for the start command",
      );
    });
  });

  describe("error", function () {
    it("Unhandled leftover", function () {
      return new Promise(function (resolve, reject) {
        shell({
          router: {
            stderr: writer(resolve),
            stderr_end: true,
            error_help: true,
          },
        })
          .route(["invalid", "leftover"])
          .catch(reject);
      }).then(function (output) {
        output.should.containEql(
          'Invalid Argument: fail to interpret all arguments "invalid leftover"',
        );
        output.should.containEql("myapp - No description yet");
      });
    });

    it("Undeclared options in stric mode", function () {
      return new Promise(function (resolve, reject) {
        shell({
          router: {
            stderr: writer(resolve),
            stderr_end: true,
            error_help: true,
          },
          strict: true,
        })
          .route(["--opt", "val"])
          .catch(reject);
      }).then(function (output) {
        output.should.containEql(
          "Invalid Argument: the argument --opt is not a valid option",
        );
        output.should.containEql("myapp - No description yet");
      });
    });

    it("Undeclared options inside a command in stric mode", function () {
      return new Promise(function (resolve, reject) {
        shell({
          commands: {
            server: {},
          },
          router: {
            stderr: writer(resolve),
            stderr_end: true,
            error_help: true,
          },
          strict: true,
        })
          .route(["server", "--opt", "val"])
          .catch(reject);
      }).then(function (output) {
        output.should.containEql(
          "Invalid Argument: the argument --opt is not a valid option",
        );
        output.should.containEql(
          "myapp server - No description yet for the server command",
        );
      });
    });
  });
});
