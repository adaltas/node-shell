/*

Call example with:

* `node samples/help.js --help`
* `node samples/help.js help`

It prints:

```
// start-snippet{output}

// end-snippet{output}
```
*/

import { shell } from "shell";

const params = shell({
  name: "precious",
  description: "Manage your precious",
  commands: {
    secrets: {
      options: {
        database: {
          shortcut: "d",
          description: "Where to store your secrets",
        },
      },
      commands: {
        set: {
          options: {
            key: {
              shortcut: "h",
            },
            value: {
              shortcut: "v",
            },
          },
        },
      },
    },
  },
});

// start-snippet{sample}
const args = params.parse();
const commands = params.helping(args);
if (commands) {
  process.stdout.write(params.help(commands));
}
// end-snippet{sample}
