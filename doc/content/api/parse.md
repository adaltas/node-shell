---
title: API method `parse`
navtitle: parse
description: How to use the `parse` method to convert an arguments list to data.
keywords: ["shell", "node.js", "cli", "api", "parse", "arguments", "argv", "array"]
maturity: review
---

# Method `parse([arguments])`

Convert an arguments list to data.

* `arguments` (process | string, optional, `process`)   
  The input arguments to parse, accept the [Node.js process](https://nodejs.org/api/process.html) instance or an [argument list](https://nodejs.org/api/process.html#process_process_argv) provided as an array or a string, optional, default to `process`.
* `options` (object)   
  Options used to alter the behavior of the `compile` method.
  * `extended` (boolean, optional, `false`)   
  The value `true` indicates that the data is returned in extended format, default to the configuration `extended` value which is `false` by default.
* Returns: (object | [object])   
  The extracted data, an object literal in flatten mode or an array of object literals in extended mode.

## Description

The method convert an array containing the command line arguments into a literal object in flatten mode or an array in extended mode.

Only pass the data without the script name when providing an argument list in the form of an array or a string. It obtains the arguments from `process.argv` when `arguments` is not provided or is the [Node.js process](https://nodejs.org/api/process.html).

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

Called with only the `--config` argument, the `parse` method convert the shell command into a literal object:

```js
app.parse([
  "--config", "app.yml"
])
.should.eql({
  config: "app.yml"
})
```

In extended mode, the output will be an array instead of an object:

```js
app.parse([
  "--config", "app.yml"
], {
  extended: true
})
.should.eql([{
  config: "app.yml"
}])
```

Working with commands is quite similar:

```javascript
app.parse(
  ["--config", "app.yml", "start", "--host", "127.0.0.1", "-p", "80"]
)
.should.eql({
  config: "app.yml",
  command: ["start"],
  host: "127.0.0.1",
  port: 80
});
```

In extended mode, the output will be an array with 2 elements instead of an object:

```javascript
app.parse([
  "--config", "app.yml", "start", "--host", "127.0.0.1", "-p", "80"]
], {
  extended: true
})
.should.eql([{
  config: "app.yml"
}, {
  command: "start",
  host: "127.0.0.1",
  port: 80
}]);
```
