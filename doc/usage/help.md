
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

In the end, using the `help` option of the "secrets set" command or using `help` command with "secret set" as arguments are are equivalent and work by default:

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
