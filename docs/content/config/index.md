---
title: Configuration
description: Configuration object for passing as an argument to the function
keywords: ['shell', 'node.js', 'cli', 'usage', 'config', 'configuration']
maturity: review
---

# Configuration

The configuration parameter is an object passed as an argument to the function which is exported by this package.

```js
shell = require("shell")
app = shell(config)
```

## The root properties

* [`commands`](./commands/) (object|array, optional)   
  Group the arguments into multiple sections. Support object and array notation. If defined as an object, keys correspond to the "name" properties. If defined as  an array, the "name" property is required.
* `description` (string, optional)
  The description of the application.
* [`extended`](/usage/extended/) (boolean, optional, false)   
  Switch the format of the data between the simple flatten mode and the safer extended mode.
* [`router`](./router) (object, optional)   
  An object configuring the router plugin with low level properties.
* [`load`](./load/) (function|string, optional)   
  Function or a module referencing the function to load modules, the default implementation ensure modules starting with './' are relative to 
  `process.cwd()` and use `require.main.require`.
* [`main`](./main/) (object, optional)   
  Anything left which is not a parameter at the end of the arguments.
* `name` (string, optional)
  The name of the application, used by the help plugin to display information.
* [`options`](./options/) (object|array, optional)
  Defined the expected command options, sometimes called flags.
* `route` (function|string, optional)   
  Execute a function or the function exported by a module if defined as a  string, provide the params object, see the [routing documentation](/api/route/).
* `strict` (boolean, optional, false)   
  Disable auto-discovery.

## Initialisation

The configuration is commonly passed as the main argument when initialising `shell`:

```js
const shell = require('shell')
const app = shell({
  name: 'my_new_app'
  main: 'some_param'
})
console.log(app.parse())
```

It is however easy to externalize the configuration into an external file stored on the file system. JSON being natively handled by Node.js, here is how an application could rely on a configuration file stored in "/etc/my_new_app.json":

```js
const config = require('/etc/my_new_app')
const shell = require('shell')
const app = shell(config)
console.log(app.parse())
```
