---
title: API method `route`
description: How to use the `route` method to execute code associated with a particular command.
keywords: ["parameters", "node.js", "cli", "api", "router", "command", "route"]
maturity: initial
---

# Method `route([cli_arguments], ...users_arguments)`

How to use the `route` method to execute code associated with a particular command.

* `cli_arguments`: `[string] | process` The arguments to parse into parameters, accept the [Node.js process](https://nodejs.org/api/process.html) instance or an [argument list](https://nodejs.org/api/process.html#process_process_argv) provided as an array of strings, optional, default to `process`.
* `...users_arguments`: `any` Any arguments that will be passed to the executed function associated with a route.
* Returns: `any` Whatever the route function returns.

## Description

The method dispatch the commands of the CLI application into function based on the `route` configuration property of the application or of a command. If the value is a string, it is interpreted as a module which will be loaded and which must export a function.

The route function receive as first argument a context object with the following properties:

* `argv`   
  The CLI arguments, either passed to the `route` method or obtained from `process.argv`.
* `params`   
  The parameters object derived from `argv`, will change form between flatten and extended mode.
* `config`   
  The configuration object used to initialise the parameters instance.

## Examples

Considering a "server" application containing a "start" and a "stop" commands, each commands define a `route` function:

```js
require("should")
const parameters = require("parameters")
const app = parameters(
{ name: "server",
  commands:
  { "start":
    { options:
      { "host":
        { shortcut: "h",
          description: "Web server listen host"},
        "port":
        { shortcut: "p", type: "integer",
          description: "Web server listen port" } }
      route: "./routes/start.js" } } })
app.route()
```

The file "./routes/start.js" could look like:

```js
module.exports = ({argv, params, config}) ->
  process.stderr.write(`Listen address is ${params.host}:${params.port}`)
```
