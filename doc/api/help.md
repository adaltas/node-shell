
# Method `help`

Format the configuration into a readable documentation string.

* `help(command)`
  * `command`: `[string] | string` The string or array containing the command name if any, optional
  * Returns: `string` The formatted help to be printed.

## Integration

Without any argument, the `help` method return the application help without the specific documentation of each sub commands. With the command name, it returned the help of the requested command as well as the options of the parent commands and application.

### Standard command line example

```javascript
app = parameters({
  name: 'server',
  description: 'Start a web server',
  options: [{
    name: 'host', shortcut: 'h', 
    description: 'Web server listen host'
  },{
    name: 'port', shortcut: 'p', type: 'integer', 
    description: 'Web server listen port'
  }]
});
// Print help
process.stdout.write( app.help() );
```

### Command-based command line example

```javascript
app = parameters({
  name: 'server',
  description: 'Manage a web server',
  commands: [{
    name: 'start',
    description: 'Start a web server',
    options: [{
      name: 'host', shortcut: 'h', 
      description: 'Web server listen host'
    },{
      name: 'port', shortcut: 'p', type: 'integer', 
      description: 'Web server listen port'
    }]
  }]
});
// Print help
process.stdout.write( app.help() );
```


## Implementation

### Argument `--help`

Internally, an empty configuration by default register the `help` option by default:

```js
require("assert")
.deepStrictEqual(
  require("parameters")({}).config.options,
  { help:
    { name: 'help',
      shortcut: 'h',
      description: 'Display help information',
      type: 'boolean',
      help: true } }
)
```

The same apply to every commands:

```js
require("assert")
.deepStrictEqual(
  require("parameters")(
  { commands:
    { mycmd: {} } }).config.commands.mycmd.options,
  { help:
    { name: 'help',
      shortcut: 'h',
      description: 'Display help information',
      type: 'boolean',
      help: true } }
)
```

### Command `--help`

Internally, an `help` command is registered if at least another command is defined:

```js
require("assert")
.deepStrictEqual(
  require("..")({commands:[{name: 'secret'}]}).config.commands.help,
  { name: 'help',
    description: 'Display help information about myapp',
    main:
    { name: 'name', description: 'Help about a specific command' },
      help: true,
      strict: false,
      shortcuts: {},
      command: 'command',
      options: {},
      commands: {} }
)
```
