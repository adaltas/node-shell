---
title: API method `help`
navtitle: help
description: How to use the `help` method to print help to the user console.
keywords: ['shell', 'node.js', 'cli', 'api', 'help', 'print']
maturity: review
---

# Method `help(commands, options)`

Format the configuration into a readable documentation string.

* `commands` ([string] | string)   
  The string or array containing the command name if any, optional.
* `options.extended` (boolean)   
  Print the child command descriptions, default is `false`.
* `options.indent` (string)   
  Indentation used with output help, default to 2 spaces.

All options are optional.

It returns the formatted help to be printed as a string.

## Description

Without any argument, the `help` method returns the application help without the specific documentation of each commands. With the command name, it returns the help of the requested command as well as the options of the application and any parent commands.

Calling `help` will always return a string, it does not detect if help was requested by the user for display. To achieve this behaviour, it is expected to be used conjointly with [`helping`](/api/helping/), see the [the help usage documentation](/usage/help/) for additional information.

## Examples

Considering a "server" application containing a "start" command and initialized with the following configuration:

`embed:api/help/example.js`

To print the help of the overall application does not require any arguments. It behaves the same as calling the `help` method with an empty array.

```js
process.stdout.write( app.help() )
process.stdout.write( app.help( [] ) )
```

Pass the name of the command as an array to print the help of any nested command. It behaves the same as defining the command as a string.

```js
process.stdout.write( app.help( ['start'] ) );
process.stdout.write( app.help( 'start' ) );
```

## Implementation

### Argument `--help`

The `help` option is registered by default:

`embed:api/help/option_root.js`

The same apply to every commands:

`embed:api/help/option_commands.js`

### Command `help <commands...>`

Internally, an `help` command is registered if at least another command is defined:

`embed:api/help/command.js`
