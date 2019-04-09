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

* `commands` (object)   
  Group the parameters into a specific command. Support object and array notation. If
  defined as an object, keys correspond to the "name" properties. If defined as 
  an array, the "name" property is required.
* `load` (function|string)   
  Function or a module referencing the function to load modules, the default
  implementation ensure modules starting with './' are relative to 
  `process.cwd()` and use `require.main.require`.
* `main` (object)   
  Anything left which is not a parameter at the end of the arguments.
* `options` (object)
  Defined the expected main parameters.
* `strict` (boolean)   
  Disable auto-discovery.

### The properties for `commands` are

* `name` (string)   
  The command name.
* `options` (object|array)
  Defined the expected command parameters. Support object and array notation. If
  defined as an object, keys correspond to the "name" properties. If defined as 
  an array, the "name" property is required.

## The properties for `main`

* `name` (string)   
  The name of the main property.
* `required` (boolean)   
  Whether or not the value must always be present.

## The properties for `options`

Described on the [Option page](./options)
