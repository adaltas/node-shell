---
title: Displaying the help
description: How to use the help.
keywords: ['shell', 'node.js', 'cli', 'usage', 'help', 'print']
maturity: review
sort: 2
---

# Displaying the help

## Description

Help prints detailed information about how to use the CLI application or one of its commands.

## How to display the help

From a user perspective, there are multiple ways to print the help to the console:

* by passing the `--help` option in the command, for example `./app print --help`.
* if commands are used, by calling the `help` command, eventually followed by any command, for example `./app help print`.
* when the command is invalid or incomplete, for example `./app print`, assuming the `print` command has a required `message` option.
* when calling a non-leaf command, for example `./app plugin`, assuming `plugin` is not a command in itself but a group of multi-level commands such as `./app plugin print -m 'hello'`.

Use `./myapp --help` to print the help usage of the overall application. The `help` option is automatically registered to the application as well as to every commands.

If at least one command is registered, use `./myapp help` to print the usage of the application or `myapp help <command...>` to print the usage of specific commands.

For example, an application `myapp` which has a command `secrets` with a command `set` could print the usage of the group of multi-level command `secrets set` with the arguments `./myapp help secrets set`.

In the end, using the `help` option of the "secrets set" command or using `help` command with "secret set" as arguments are equivalent and work by default:

```bash
# Option
./myapp secrets set --help
# Command
./myapp help secrets set
```

## Integration

### Using `helping`

For the developer, printing help uses a combination of the `helping` and `help` methods. The `helping` method takes the parsed data and check if printing help is requested. The `help` method return the usage information as string.

Here's how to display help with `helping` and `help`:

`embed:help.js{snippet: "sample"}`

The output looks like:

`embed:help.out`

### With routing

Routing is enabled if the application or its command defined the `route` property which point to a function or a module name.

Here's how to display help with routing:

```js
// Routing to help required `help.route` to be set
const shell = require('shell')
shell({
  handler: './some/module'
}).route(/*...optional user arguments...*/)
```

### Invalid or incomplete command

TODO: describe how help could be printed when an error occurred.

### Non-leaf command

TODO: describe how help could be printed for every non leaf command if requested.

### Overwriting

It is possible to overwrite the default help options and commands such as to provide a personalised message:

```js
const shell = require('shell')
shell = ({
{ options:
  { help: 
    { description: 'Overwrite description' } } }
)
```
