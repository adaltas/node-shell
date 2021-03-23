---
title: API method `load`
navtitle: load
description: How to use the `load` method to load modules.
keywords: ['parameters', 'node.js', 'cli', 'api', 'load', module]
maturity: initial
---

# Method `load(module)`

* `load`   
  type: "function"   
  arguments:   
  * `module`:   
    type: "string"

## Description

Internal function used to load modules. It returns the module.

It is possible to customize the loading behavior with a custom function. The [`load`](/config/load/) configuration provides an entry point to place user defined functions or the path to a module exporting a user defined function.

The default behavior search for relative module path from the current working directory with `process.cwd()`. Internally, it uses the function `require.main.require`.

## Examples

TODO: Add a representative example
