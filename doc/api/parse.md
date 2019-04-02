
# Method `parse`

The `parse` method converts array containing the command line arguments passed when the Node.js process was launched into a literal object or an array in extended mode.

* `parse(argv)`
  * `argv`: `[string] | process` The [argument array](https://nodejs.org/api/process.html#process_process_argv) or the [Node.js process](https://nodejs.org/api/process.html) to be converted into parameters, required
  * Returns: `object | [object]` The extracted parameters, a literal object in default flatten mode or an array in extended mode.

## Integration

### Standard command line example

```javascript
require("should")
require("parameters")({
  name: "server",
  description: "Start a web server",
  options: [{
    name: "host", shortcut: "h", 
    description: "Web server listen host"
  },{
    name: "port", shortcut: "p", type: "integer", 
    description: "Web server listen port"
  }]
});
// Convert the command to a literal object
.parse(
  ["--host", "127.0.0.1", "-p", "80"]
).should.eql({
  host: "127.0.0.1",
  port: 80
});
```

### Command-based command line example

```javascript
require("should")
require("parameters")({
  name: "server",
  description: "Manage a web server",
  commands: [{
    name: "start",
    description: "Start a web server",
    options: [{
      name: "host", shortcut: "h", 
      description: "Web server listen host"
    },{
      name: "port", shortcut: "p", type: "integer", 
      description: "Web server listen port"
    }]
  }]
});
// Convert the command to a literal object
.parse(
  ["start", "--host", "127.0.0.1", "-p", "80"]
).should.eql({
  command: ["start"],
  host: "127.0.0.1",
  port: 80
});
```
