
# Help usage

Help print detailed information about how to use a command or one of its sub commands.

## Usage

From a user perspective, there are multiple ways to print the help to the console:
* by passing the `--help` argument in the command or after a sub command, for example `./app print --help`.
* by calling the `help` command, eventually followed by a sub command, if other commands are registered, for example `./app help print`.
* when the command is invalid or incomplete, for example `./app print`, assuming the `print` command has a required `message` option.
* when calling a non-leaf command, for example `./app plugin`, assuming `plugin` is not a command in itself but a group of sub commands such as `./app plugin print -m 'hello'`.

Use `./myapp --help` to print the help usage of the overall application. The `help` option is automatically registered to the application as well as to every commands.

If at least one command is registered, use `./myapp help` to print the usage of the application or `myapp help <command...>` to print the usage of specific commands

For example, an application `myapp` which has a command `secrets` with a sub command `set` could print the usage of the subcommand `secrets set` with the arguments `./myapp help secrets set`.

In the end, using the `help` option or using `help` command are are equivalent and work by default:

```
# Option
./myapp secrets set --help
# Command
./myapp help secrets set
```

## Integration

### Using `helping`

For the developer, printing help uses a combination of the `helping` and 
`help` methods. The `helping` method takes the parsed parameters and check if printing help is requested. The `help` method return the usage information as string.

Here's how to display help with `helping` and `help`:

```javascript
const params = require('parameters')(my_config);
const args = params.parse()
if(commands = params.helping(args)){
  return process.stdout.write(params.help(commands));
}
// Now work with the args object
```

### With routing

Routing is enabled if the application or its command defined the `run` property which point to a function or a module name.

Here's how to display help with routing:

```javascript
// Routing to help required `help.run` to be set
my_config.help = {run: './some/module'}
require('parameters')(my_config).run(/*...user_arguments...*/)
```

### Invalid or incomplete command

TODO: describe how help could be printed when an error occured.

### Non-leaf command

TODO: describe how help could be printed for every non leaf command if requested.

### Overwriting

It is possible to overwrite the default help options and commands such as to provide a personalised message:

```
require('parameters')({
{ options:
  { help: 
    { description: 'Overwrite description' } } }
)
```

## Standard command line example

```javascript
command = parameters({
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
console.log( command.help() );
// Extract command arguments
// Note, if the argument array is undefined, it default to `process.argv`
// and is similar to running the command
// `node samples/commands.js --host 127.0.0.1 -p '80'`
// from the project home directory
command.parse(
  ['--host', '127.0.0.1', '-p', '80']
).should.eql({
  host: '127.0.0.1',
  port: 80
});
// Create a command
command.stringify({
  host: '127.0.0.1',
  port: 80
}).should.eql(
  ['--host', '127.0.0.1', '--port', '80']
);
```

## Command-based command line example

```javascript
command = parameters({
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
console.log( command.help() );
// Extract command arguments
// Note, if the argument array is undefined, it default to `process.argv`
// and is similar to running the command
// `node samples/commands.js start --host 127.0.0.1 -p '80'`
// from the project home directory
command.parse(
  ['start', '--host', '127.0.0.1', '-p', '80']
).should.eql({
  command: 'start',
  host: '127.0.0.1',
  port: 80
});
// Create a command
command.stringify({
  command: 'start',
  host: '127.0.0.1',
  port: 80
}).should.eql(
  ['start', '--host', '127.0.0.1', '--port', '80']
);
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
