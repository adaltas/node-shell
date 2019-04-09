---
title: API
description: API methods supported.
keywords: ['parameters', 'node.js', 'cli', 'api', 'help', 'parse', 'load', 'route', 'stringify']
maturity: review
---

# API 

The parameters package is made available to your module with the declaration
`const parameters = require('parameters');`. The returned variable is a function
expecting a configuration object and returning the following functions:

* [`help`](./help/) (command)   
  Format the configuration into a readable documentation string.
* [`parse`](./parse/) ([arguments])   
  Convert an arguments list to a parameters object.
* [`load`](./load/) (module[string])   
  Internal function used to load modules, see the "load" option to pass a
  function or a module referencing the function.
* [`route`](./route/) (argv[array|process], args[mixed]...)   
  Similar to parse but it will also call the function defined by the "route"
  option. The first argument is the arguments array to parse, other arguments
  are simply transmitted to the `route` method or module as additional arguments.
  The `route` method provided by the user receives the parsed parameters as its
  first argument. If the option "extended" is activated, it also receives the
  original arguments and configuration as second and third arguments. Any user
  provided arguments are transmitted as is as additional arguments.
* [`stringify`](./stringify/) (command, [options])   
  Convert a parameters object to an arguments array.
