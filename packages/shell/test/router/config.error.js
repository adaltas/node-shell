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

describe("router.config.error", function () {
  it("error_help true", function () {
    return new Promise(function (resolve) {
      shell({
        handler: () => {
          return Promise.reject(Error("Catch me"));
        },
        router: {
          stderr: writer(resolve),
          stderr_end: true,
          error_help: true,
        },
      })
        .route([])
        .catch(() => {});
    }).then(function (output) {
      output.should.containEql("myapp - No description yet");
    });
  });

  it("error_help false", function () {
    return new Promise(function (resolve) {
      shell({
        handler: () => {
          return Promise.reject(Error("Catch me"));
        },
        router: {
          stderr: writer(resolve),
          stderr_end: true,
        },
      })
        .route([])
        .catch(() => {});
    }).then(function (output) {
      output.should.not.containEql("myapp - No description yet");
    });
  });
});
