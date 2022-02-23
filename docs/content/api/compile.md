---
title: API method `compile`
navtitle: compile
description: How to use the `compile` method to convert an object to an arguments array.
keywords: ["shell", "node.js", "cli", "api", "compile", "arguments", "argv", "array"]
maturity: review
---

# Method `compile(command, [options])`

Convert data to an arguments array.

* `data` (object, optional)   
  The data to be converted into an array of arguments.
* `options` (object)   
  Options used to alter the behavior of the `compile` method.
  * `extended` (boolean, optional, `false`)   
  The value `true` indicates that the parameters are provided in extended format, default to the configuration `extended` value which is `false` by default.
  * `script` (string, optional, `false`)   
  The JavaScript file being executed by the Node.js engine. When provided, the Node.js engine and the script names will prepend the returned arguments.
* Returns: (array)   
  The command line arguments.

## Description

To compile an object is the reverse process of processing an array of arguments with the `parse` function. In that sense, Shell.js is bi-directional, it can both convert arguments to objects and back from objects to arguments.

It supports both the default flatten mode and the extended mode. The `extended` property can be defined in the configuration or as an option of `compile`. In flatten mode, the `command` argument is an object while in `extended` mode it is an array of object.

## Examples

Considering a "server" application containing a "start" command and initialised with the following configuration:

```js
require("should")
const shell = require("shell")
const app = shell(
{ name: "server",
  description: "Manage a web server",
  options:
  { "config":
    { shortcut: "c" } },
  commands:
  { "start":
    { description: "Start a web server",
      options:
      { "host":
        { shortcut: "h",
          description: "Web server listen host"},
        "port":
        { shortcut: "p", type: "integer",
          description: "Web server listen port" } } } } })
```

Called with only the `config` option, the `compile` method convert an object literal into a shell command:

```javascript
app.compile({
  config: "app.yaml"
})
.should.eql( [ "--config", "app.yaml" ] )
```

In extended mode, the data input will be an array instead of an object:

```js
app.compile([{
  config: "app.yaml"
}], {
  extended: true
})
.should.eql( [ "--config", "app.yaml" ] )
```

Working with commands is quite similar:

```js
app.compile({
  config: "app.yml",
  command: ["start"],
  host: "127.0.0.1",
  port: 80
}).should.eql(
  ["--config", "app.yml", "start", "--host", "127.0.0.1", "--port", "80"]
);
```

In extended mode, the data input will be an array with 2 elements instead of an object:

```js
app.compile([{
  config: "app.yml"
},{
  command: "start",
  host: "127.0.0.1",
  port: 80
}]).should.eql(
  ["--config", "app.yml", "start", "--host", "127.0.0.1", "--port", "80"]
);
```
