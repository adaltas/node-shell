---
title: API method `route`
navtitle: route
description: How to use the `route` method to execute code associated with a particular command.
keywords: ["shell", "node.js", "cli", "api", "router", "command", "route"]
maturity: initial
---

# Method `route(context, ...users_arguments)`

The `route` method dispatch command into handler function. The `handler` is a function or the the name of the module exporting the function. Learn more about [routing](/usage/routing/) in the usage documentation.

* `context`: `[string] | object` The arguments to parse into data, accept the [Node.js process](https://nodejs.org/api/process.html) instance, an [argument list](https://nodejs.org/api/process.html#process_process_argv) provided as an array of strings or the context object; optional, default to `process`.
* `...users_arguments`: `any` Any arguments that will be passed to the executed handler function associated with a route.
* Returns: `any` Whatever the route function returns.

How to use the `route` method to execute code associated with a particular command.

## Description

The first argument of the handler function is a context object with the following properties:

* `argv`   
  The CLI arguments, either passed to the `route` method or obtained from `process.argv`.
* `params`   
  The object derived from `argv`, will change form between flatten and extended mode.
* `config`   
  The configuration object used to initialise the Shell.js instance.

## Examples

Considering a "server" application containing a "start" and a "stop" commands, each commands define a `handler` which point to a module exporting a function:

```js
const shell = require("shell")
const app = shell(
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
      handler: "./routes/start.js" } } })
app.route()
```

The file "./routes/start.js" could look like:

```js
module.exports = ({argv, params, config}) ->
  process.stderr.write(`Listen address is ${params.host}:${params.port}`)
```
