---
title: API
description: API methods supported.
keywords: ['shell', 'node.js', 'cli', 'api', 'help', 'parse', 'load', 'route', 'compile']
maturity: review
sort: 3
---

# API 

Shell.js is written as an ESM package. It is also available as a CommonJS package. To import the package, uses:

```js
// ESM package
import { shell } from 'shell';
// CommonJS package
const shell = require('shell');
```

A Shell.js application is initilized with a [configuration](/config/) object:

```js
const config = {};
const app = shell(config);
```

It exposes the following functions:

* [`shell.compile`](./compile/) (command, [options])   
  Convert data to an arguments array.
* [`shell.help`](./help/) (command)   
  Format the configuration into a readable documentation string.
* [`shell.helping`](./helping/) (command)   
  Determine if help was requested by returning zero to n commands if help is requested or null otherwise.
* [`shell.load`](./load/) (module[string])   
  Internal function used to load modules, see the [`load`](/config/load/) option to pass a function or a module referencing the function.
* [`shell.parse`](./parse/) ([arguments])   
  Convert an arguments list to a data object.
* [`shell.route`](./route/) (argv[array|process], args[mixed]...)   
  Similar to parse but it will also call the function defined by the "route"
  option. The first argument is the arguments array to parse, other arguments
  are simply transmitted to the `route` method or module as additional arguments.
  The `route` method provided by the user receives the parsed data as its
  first argument. If the option "extended" is activated, it also receives the
  original arguments and configuration as second and third arguments. Any user
  provided arguments are transmitted as is as additional arguments.
