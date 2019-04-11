---
title: Configuration
description: Configuration object for passing as an argument to the function
keywords: ['parameters', 'node.js', 'cli', 'usage', 'config', 'configuration']
maturity: review
---

# Configuration

The configuration parameter is an object passed as an argument to the function
which is exported by this package.

```js
parameters = require("parameters")
app = parameters(config)
```

## The root properties

* [`commands`](./commands/) (object)   
  Group the parameters into a specific command. Support object and array notation. If
  defined as an object, keys correspond to the "name" properties. If defined as 
  an array, the "name" property is required.
* [`extended`](/usage/extended/) (boolean)   
  Switch the format of the parameters between the simple flatten mode and the more verbose and flexible extended mode.
* [`load`](./load/) (function|string)   
  Function or a module referencing the function to load modules, the default
  implementation ensure modules starting with './' are relative to 
  `process.cwd()` and use `require.main.require`.
* [`main`](./main/) (object)   
  Anything left which is not a parameter at the end of the arguments.
* [`options`](./options/) (object)
  Defined the expected main parameters.
* `strict` (boolean)   
  Disable auto-discovery.

## The properties for `help`

* `writer` (string|StreamWriter)   
  Where to print the help output. Possible string values include "stdout" and "stderr" and default to "stderr". The property is used internally by the help route.
* `route` (function|string)   
  The function or module name of the route which responsible for printing help information.

## JSON configuration

Place the configuration inside "config.json", and create a file "index.js" at 
the root of your project which looks like:

```
config = require('./config')
require('parameters').route(config)
```
