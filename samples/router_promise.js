/*

Call example with:

* `node samples/router_promise.js samples`

It prints:

```
=============
total 72
-rw-r--r--  1 david  staff   1.6K Feb 22 23:04 commands.js
-rw-r--r--  1 david  staff   1.0K Feb 22 22:58 help.js
-rw-r--r--  1 david  staff   116B Feb 22 23:04 main_empty.js
-rw-r--r--  1 david  staff   142B Feb 22 23:00 package.json
-rw-r--r--  1 david  staff   348B Nov 24  2020 router.js
-rw-r--r--  1 david  staff   1.2K Feb 22 23:16 router_promise.js
-rw-r--r--  1 david  staff   1.1K Nov 24  2020 standard.js
-rw-r--r--  1 david  staff   922B Feb 22 22:57 yarn-error.log
-rw-r--r--  1 david  staff   1.5K Feb 22 22:57 yarn.lock
-------------
Command succeed!
=============
```
*/

import { shell } from "shell";
import { spawn } from "child_process";

console.log("=============");

const result = await shell({
  commands: {
    list: {
      main: "input",
      handler: async function ({ params, stderr, stdout }) {
        return new Promise(function (resolve, reject) {
          const ls = spawn("ls", ["-lh", ...params.input]);
          ls.stderr.pipe(stderr);
          ls.stdout.pipe(stdout);
          ls.on("close", (code) => {
            code === 0
              ? resolve("Command succeed!")
              : reject(new Error(`Command failed with code: ${code}`));
          });
        });
      },
    },
  },
}).route();

console.log("-------------");
console.log(result);
console.log("=============");
