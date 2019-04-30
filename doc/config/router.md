---
title: Router property configuration
description: How to use load property.
keywords: ['parameters', 'node.js', 'cli', 'usage', 'load']
maturity: initial
---

# Router

The `router` property is object which provide low level access to modify the behaviour of the router plugin.

* `writer` (string|StreamWriter)   
  Where to print the help output. Possible string values include "stdout" and "stderr" and default to "stderr". The property is used internally by the help route.
* `route` (function|string)   
  The function or module name of the route which responsible for printing help information.
* `end` (boolean, false)   
  Close the stream writer when the command has been processed.

Note, the `writer` and `end` properties are used internally by the `help` route.
