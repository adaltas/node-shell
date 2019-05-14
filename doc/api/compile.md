---
title: API method `compile`
description: How to use the `compile` method to convert a parameters object to an arguments array.
keywords: ["parameters", "node.js", "cli", "api", "compile", "arguments", "argv", "array"]
maturity: review
---

# Method `compile(command, [options])`

Convert a parameters object to an arguments array.

* `params`: `object` The parameter object to be converted into an array of arguments, optional.
* `options`: `object` Options used to alter the behavior of the `compile` method.
  * `extended`: `boolean` The value `true` indicates that the parameters are provided in extended format, default to the configuration `extended` value which is `false` by default.
  * `script`: `string` The JavaScript file being executed by the engine, when present, the engine and the script names will prepend the returned arguments, optional, default is false.
* Returns: `array` The command line arguments.

## Description

To compile parameters is the reverse process of processing an array of arguments. In that sense, this module is bi-directional, it can both convert arguments to objects and back from objects to arguments.

It supports both the default flatten mode and the extended mode. The `extended` property can be defined in the configuration or as an option of `compile`. In flatten mode, the `command` argument is an object while in `extended` mode it is an array of object.

## Examples

Considering a "server" application containing a "start" command and initialised with the following configuration:

```js
require("should")
const parameters = require("parameters")
const app = parameters(
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

Called with only the `config` option, the `compile` method convert a literal object into a shell command:

```javascript
app.compile({
  config: "app.yaml"
})
.should.eql( [ "--config", "app.yaml" ] )
```

In extended mode, the parameters input will be an array instead of an object:

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

In extended mode, the parameters input will be an array with 2 elements instead of an object:

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
