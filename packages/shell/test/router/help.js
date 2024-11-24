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

describe("router.help", function () {
  it("Unhandled leftover", function () {
    return new Promise((resolve) => {
      shell({
        router: {
          stderr: writer(function (output) {
            resolve(output);
          }),
          stderr_end: true,
        },
      }).route(["invalid", "leftover"]);
    }).then((output) => {
      output.should.match(
        /^\s+Invalid Argument: fail to interpret all arguments "invalid leftover"/,
      );
      output.should.match(/^\s+myapp - No description yet/m);
    });
  });

  it("Undeclared options in stric mode", function () {
    return new Promise((resolve) => {
      shell({
        router: {
          stderr: writer(function (output) {
            resolve(output);
          }),
          stderr_end: true,
        },
        strict: true,
      }).route(["--opt", "val"]);
    }).then((output) => {
      output.should.match(
        /^\s+Invalid Argument: the argument --opt is not a valid option/,
      );
      output.should.match(/^\s+myapp - No description yet/m);
    });
  });

  it("Undeclared options inside a command in stric mode", function () {
    return new Promise((resolve) => {
      shell({
        commands: {
          server: {},
        },
        router: {
          stderr: writer(function (output) {
            resolve(output);
          }),
          stderr_end: true,
        },
        strict: true,
      }).route(["server", "--opt", "val"]);
    }).then((output) => {
      output.should.match(
        /^\s+Invalid Argument: the argument --opt is not a valid option/,
      );
      output.should.match(
        /^\s+myapp server - No description yet for the server command/m,
      );
    });
  });
});
