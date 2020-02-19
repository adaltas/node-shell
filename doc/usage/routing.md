---
title: Routing
description: Route commands to individual handler functions.
keywords: ['parameters', 'node.js', 'cli', 'usage', 'routing', 'route', 'handler', 'fucntion']
maturity: initial
sort: 4
---

# Routing

Routing dispatch the commands of the CLI application into user provided handler function. The handler function are defined by the `route` configuration property of the application or of a command.

Help is automatically activated when using routing. A new help command is registered as well as the `--help -h` option to each commands.

## Configuration

The `router` configuration property define the routing behaviour. It is available at the application level as well as for every command. Refer to the [`router` configuration property](/config/router/) for additional information.

## Execution

Routing is executed by calling `route` method on the parameter instance. Refer to the [`route` method API](/api/route/) for additional information.

## Handler function

Arguments are transparently parsed and the handler function associated to the application or a command is called with a context object as first argument. The context contains the following properties:

* `argv`   
   CLI arguments.
* `command` ([string])   
  The command being called, an empty array if no command is executed.
* `error`   
   Error object if any error was thrown when parsing the arguments. The property is used internally to provide the error object to the help routing function.
* `params`   
   Extracted parameters from `argv`
* `stderr`   
  The StreamWriter where to redirect error data.
* `stderr_end`   
  The StreamWriter where to redirect error data.
* `stdout`   
  The StreamWriter where to redirect standard data.
* `stdout_end`   

## Example

[The router example](https://github.com/adaltas/node-parameters/blob/master/samples/router.js) defines a `list` command which print the files of a directory:

```js
const parameters = require('parameters')
const { spawn } = require('child_process')

parameters({
  commands: {
    'list': {
      main: {
        name: 'input', required: true
      },
      options: {
        port: {
          type: 'integer'
        }
      },
      route: async function({params, stderr, stdout}){
        const ls = spawn('ls', ['-lh', ...params.input])
        ls.stderr.pipe(stderr)
        ls.stdout.pipe(stdout)
      }
    }
  }
}).route()
```

You can test the behavior of this command with `node samples/router.js list {a_directory}`. For example, if you are inside the root folder of this project repository, executing `node samples/router.js list ./src` prints the files of the ["src" directory](https://github.com/adaltas/node-parameters/blob/master/src/).

You can verify that `stdout` and `stderr` are honored:

```
# stdout is redirected to a file named "stdout.log"
node samples/router.js list src > ./stdout.log
# stderr is redirected to a file named "stderr.log"
node samples/router.js list invalid > ./stderr.log
```
