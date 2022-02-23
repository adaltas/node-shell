
import assert from 'assert';
import {shell} from 'shell';

assert.deepStrictEqual(
  shell({}).config.options
, {
  help: {
    cascade: true,
    description: 'Display help information',
    help: true,
    name: 'help',
    shortcut: 'h',
    type: 'boolean'
  }
});
