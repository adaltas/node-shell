import { shell } from "shell";
import { spawn } from "child_process";

shell({
  commands: {
    list: {
      main: "input",
      handler: async function ({ params, stderr, stdout }) {
        const ls = spawn("ls", ["-lh", ...params.input]);
        ls.stderr.pipe(stderr);
        ls.stdout.pipe(stdout);
      },
    },
  },
}).route();
