// Dependencies
import client from "./client.js";

const call = client().run({
  argv: process.argv.slice(2),
});

call.on("data", function ({ data }) {
  return process.stdout.write(data);
});

call.on("end", function () {
  return process.stdout.write("end");
});
