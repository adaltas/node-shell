
import assert from "assert"
import {shell} from "shell"

assert.deepStrictEqual(
  shell({
    commands: { 'secret': {} }
  }).config('help').get()
, {
    name: 'help',
    description: 'Display help information',
    main: {
      name: 'name',
      description: 'Help about a specific command' 
    },
    handler: 'shell/routes/help',
    help: true,
    strict: false,
    shortcuts: {},
    command: ['help'],
    options: {},
    commands: {}
});
