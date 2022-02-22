
/*

Call example with:

* `node samples/help.js --help`
* `node samples/help.js help`

It prints:

```
NAME
  precious - Manage your precious

SYNOPSIS
  precious <command>

OPTIONS
  -h --help                 Display help information

COMMANDS
  secrets                   No description yet for the secrets command
  help                      Display help information

EXAMPLES
  precious --help           Show this message
  precious help             Show this message
```
*/

import {shell} from 'shell';

const params = shell({
  name: 'precious',
  description: 'Manage your precious',
  commands: {
    "secrets": {
      options: {
        database: {
          shortcut: "d",
          description: "Where to store your secrets"
        }
      },
      commands: {
        "set": {
          options: {
            key: {
              shortcut: 'h'
            },
            value: {
              shortcut: "v" }}}}}}});

const args = params.parse();
const commands = params.helping(args);
if(commands){
  process.stdout.write(params.help(commands))
}
