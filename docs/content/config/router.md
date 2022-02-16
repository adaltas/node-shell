---
title: Router property configuration
description: How to use load property.
keywords: ['shell', 'node.js', 'cli', 'usage', 'load']
maturity: initial
---

# Router

The `router` property is an object which provide low level access to modify the behaviour of the router plugin. Learn more about [routing](/usage/routing/) in the usage documentation.

* `promise` (boolean, `false`)   
  Wrap all the returned value into a promise if not yet one.
* `handler` (function|string)   
  The function or the module name used to handle errors or undefined handlers.
* `stdin` ([`stream.Readable`](https://nodejs.org/api/stream.html#class-streamreadable), `process.stdin`)   
  The standard input stream reader. It default to `process.stdin` but it is
  sometime usefull to switch your own implementation such as in your tests.
* `stdout` ([`stream.Writable`](https://nodejs.org/api/stream.html#class-streamwritable), `process.stdout`)   
  The standart output stream writer. It default to `process.stdout` but it is
  sometime usefull to switch your own implementation such as in your tests. Also,
  the `grpc_server` plugin switch its own writer used to communicate with the GRPC the server.
* `stdout_end` (boolean, `false`)   
  Close the standart output stream writer when the command has been processed.
* `stderr` ([`stream.Writable`](https://nodejs.org/api/stream.html#class-streamwritable), `process.stderr`)   
  The standart error stream writer. It default to `process.stderr`. The same argument as with `stdout` apply. Note, the `help` plugin write to `stderr` by default.
* `stderr_end` (boolean, `false`)   
  Close the standart output stream writer when the command has been processed.

## Short declaration

If the `router` property is a string, it is interpreted as the module name exporting the handler function. For example:

```js
const shell = require('shell')
shell({
  router: './my/module'
})
```

Is equivalent to:

```js
const shell = require('shell')
shell({
  router: {
    handler: './my/module'
}})
```

Note, the `help` command, activated by default when a first command is registered, writes by default to `stderr` and close the stream if `stderr_end` is enabled.
