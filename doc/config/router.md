---
title: Router property configuration
description: How to use load property.
keywords: ['parameters', 'node.js', 'cli', 'usage', 'load']
maturity: initial
---

# Router

The `router` property is an object which provide low level access to modify the behaviour of the router plugin. Learn more about [routing](/usage/routing/) in the usage documentation.

* `writer` (string|StreamWriter)   
  Where to print the help output. Possible string values include "stdout" and "stderr" and default to "stderr". The property is used internally by the help route.
* `route` (function|string)   
  The handler function or the module name exporting the handler function.
* `end` (boolean, false)   
  Close the stream writer when the command has been processed.

## Short declaration

If the `route` property is a string, it is interpreted as the module name exporting the handler function. For example:

```js
const parameters = require('parameters')
parameters({
  router: './my/module'
} )
```

Is equivalent to:

```js
const parameters = require('parameters')
parameters({
  router: {
    route: './my/module'
} } )
```



Note, the `writer` and `end` properties are used internally by the `help` route.
