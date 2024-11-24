import path from "path";
import { glob } from "glob";
import { exec } from "child_process";
import { fileURLToPath } from "url";
const __dirname = path.dirname(fileURLToPath(import.meta.url));
// dir = path.resolve __dirname, '../samples'
const samples = glob.sync(`${__dirname}/../**/*.js`);
// [_, major] = process.version.match(/(\d+)\.\d+\.\d+/)

describe("Samples", function () {
  samples
    .filter((sample) => {
      return !/test/.test(sample);
    })
    .map((sample) => {
      // return unless /\.js$/.test sample
      it(`Sample ${path.relative(__dirname + "/..", sample)}`, function (callback) {
        exec(`node ${sample}`, (err) => {
          callback(err);
        });
      });
    });
});
