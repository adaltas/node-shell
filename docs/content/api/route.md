---
title: API method `route`
navtitle: shell.route
description: How to use the `route` method to execute code associated with a particular command.
keywords: ["shell", "node.js", "cli", "api", "router", "command", "route"]
maturity: initial
---

# Method `shell.route(context, ...users_arguments)`

The `route` method dispatch command into handler functions. An `handler` is a function or the name of a module exporting a function. Learn more about [routing](/usage/routing/) in the usage documentation.

* `context`: `[string] | object` The arguments to parse into data, accept the [Node.js process](https://nodejs.org/api/process.html) instance, an [argument list](https://nodejs.org/api/process.html#process_process_argv) provided as an array of strings or the context object; optional, default to `process`.
* `...users_parameters`: `any` Additionnal parameters that will be passed to the handler function associated with a route.
* Returns: `any` Whatever the handler function returns.

## Basic usage

Considering a "server" application containing a "start" and a "stop" commands, each commands define a `handler` which point to a module exporting a function:

```js
const shell = require("shell")
const app = shell({
  name: "server",
  commands: {
    "start": {
      options: {
        "host": {
          shortcut: "h",
          description: "Web server listen host"
        },
        "port": {
          shortcut: "p", type: "integer",
          description: "Web server listen port"
        }
      },
      handler: "./routes/start.js"
    }
  }
})
app.route()
```

The file "./routes/start.js" could look like:

```js
module.exports = ({argv, params, config}) => {
  process.stderr.write(`Listen address is ${params.host}:${params.port}`)
}
```

## Passing arguments

By default, the arguments are extracted from the `process.argv` array. The first two elements of the array are striped out. They corresponds to the Node.js command and the module being executed that is your application main entry point.

You can however pass your own arguments such as:

```js
app.route(['start', '--port', 3000])
```

In which case, `argv` will equals to:

```js
['start', '--port', 3000]
```

## Passing additionnal parameters

Any additionnal arguments will be passed to the `handler` function, for example, calling `app.route` with:

```js
app.route(['start', '--port', 3000], myArg, myCallback, anythingYouWant)
```

Yields to a handler like:

```
module.exports = (context, myArg, myCallback, anythingYouWant) => {
  // write your code here
  // probably calling the myCallback argument when done
}
```

## Return value

Anything returned by the handler is also returned by the `route` function. Imaging a handler returning a promise:

```js
module.exports = ({params}) => {
  return new Promise( (accept, reject) => {
    setTimeout(function(){
      params.port === 3000 ? accept() : reject()
    }, 1000)
  })
}
```

The application calling the route wait for the promise to be resolved with:

```js
await app.route(['start', '--port', 3000]
```
