---
title: API method `helping`
description: How to use the `helping` method to determine if help was requested.
keywords: ['parameters', 'node.js', 'cli', 'api', 'helping', 'help', 'print']
maturity: review
---

# Method `helping(params)`

Determine if help was requested by returning zero to n commands if help is requested or null otherwise.

* `params`: `[object] | object` The parameter object parsed from arguments, an object in flatten mode or an array in extended mode, optional.
* Returns: `array | null` The formatted help to be printed.

## Description

This method is commonly used conjointly with the `help` method. It provides an indication wether or not help was requested and the command to inject to `help`.

## Example

The workflow is to `parse` the arguments to get the parameters, to create a condition to get the command associated with help and to print the help by passing the returned command:

```js
const parameters = require('parameters')
const app = parameters({
  name: 'server',
  description: 'Manage a web server',
  commands: {
    'start': {
      description: 'Start a web server',
      options: {
        'host': {shortcut: 'h', description: 'Web server listen host'},
        'port': {shortcut: 'p', type: 'integer', description: 'Web server listen port'}
      }
    }
  }
});
const params = app.parse()
if(let command = app.helping(params)){
  const help = app.help(command)
  process.stdout.write(help)
  process.exit()
}
```

Considering the above example, the commands `./myapp help` `./myapp --help` and `./myapp -h` print the application help. The commands `./myapp help start`, `./myapp start --help` and `./myapp start -h` print the help of the `start` command.
