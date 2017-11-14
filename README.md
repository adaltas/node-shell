[![Build Status](https://secure.travis-ci.org/adaltas/node-parameters.png)](http://travis-ci.org/adaltas/node-parameters)

# `npm install parameters`

Node parameters is sugar for parsing typical unix command line options. 

*   Standard and commands-based command lines (think `git pull ...`)
*   Reversability: parse and stringify is bi-directional
*   Complete tests coverages plus samples
*   Auto-discovery: extract unregistered options

## Usage

The parameters package is made available to your module with the declaration
`parameters = require('parameters');`. The returned variable is a function
expecting a definition object and returning the following functions:

* `help` (command[string:null])   
  Returned a string with the complete help content or the content of a single 
  command if the command argument is passed.
* `parse` (argv[array:process])   
  Transform an array of arguments into a parameter object. If null
  or the native `process` object, the first two arguments (the node
  binary and the script file) are skipped.
* `load` (module[string])   
  Internal function used to load modules, see the "load" option to pass a
  function or a module referencing the function.
* `run` (argv[array:process], args[obj]...)   
  Similar to parse but also call the function or the module defined by the "run"
  option; first arguments are the arguments to parse, other arguments are simply
  passed to the run function or module as first arguments.
* `stringify` (params[obj], options[obj])   
  Convert an object of parameters into an array of arguments. Possible options
  are "no_default".

## Definition

The parameter definition is an object passed as an argument to the function exported by
this package.

The root properties are:

* `commands` (object)   
  Group the parameters into a specific command.
* `load` (function|string)   
  Function or a module referencing the function to load modules, the default
  implementation ensure modules starting with './' are relative to 
  `process.cwd()` and use `require.main.require`.
* `main` (object)   
  Anything left which is not a parameter at the end of the arguments.
* `options` (object)
  Defined the expected main parameters.
* `strict` (boolean)   
  Disable auto-discovery.

The properties for commands are:

* `name` (string)   
  The command name.
* `options` (object)
  Defined the expected command parameters.

The properties for options are:

* `default` (anything)   
  Default value if none is provided; always part of the object return by parse,
  part of the arguments returned by stringify unless the "no_default" option is 
  set.
* `main` (object)   
  Anything left which is not a parameter at the end of the arguments.
* `name` (string)   
  The name of the option.
* `one_of` (array)   
  A list of possible and accepted values.
* `required` (boolean)   
  Whether or not this option must always be present.
* `run` (function|string)   
  Execute a function or the function return by a module, provide the params 
  object as first argument and pass the returned value.
* `shortcut` (char)   
  Single character alias for the option name.
* `type` (string)   
  The type used to cast between a string argument and a JS value, not all types 
  share the same behavior. Accepted values are 'boolean', 'string', 'integer'
  and 'array'.

The properties for main are:

* `name` (string)   
  The name of the main property.
* `required` (boolean)   
  Whether or not the value must always be present.

## Help usage

Call the `help` function and pass no argument to retrieve the global help and
the name of a specific command.

Here's an example on how to integrate the help functionnality inside your code:

```javascript
params = parameters(my_config).parse())
if( params.command === 'help' ){
  return console.log(parameters.help(params.subcommand));
}
```

This will satisfy a help command with or without an extra command such as
`myscript help` and `myscript help mycommand`.

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

## Development

Tests are executed with mocha. To install it, simple run `npm install`, it will
install mocha and its dependencies in your project "node_modules" directory.

To run the tests:
```bash
npm test
```

The tests run against the CoffeeScript source files.

To generate the JavaScript files:
```bash
make build
```

The test suite is run online with [Travis][travis] against the supported 
Node.js versions.

## Contributors

*   David Worms: <https://github.com/wdavidw>
