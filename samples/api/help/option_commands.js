
import assert from 'assert';
import {shell} from 'shell';

assert.deepStrictEqual(
  shell( {
    commands: { 'my_cmd': {} }
  }).confx('my_cmd').options.show()
, {
  help: {
    cascade: true,
    shortcut: 'h',
    description: 'Display help information',
    type: 'boolean',
    help: true,
    name: 'help',
    transient: true
  }
});
