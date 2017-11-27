[![Build Status](https://secure.travis-ci.org/adaltas/node-parameters.png)](http://travis-ci.org/adaltas/node-parameters)

# `npm install parameters`

Node parameters is sugar for parsing typical unix command line options. 

* Standard and commands-based command lines (eg `git-pull ...` or `git pull ...`)
* Reversability: parse and stringify is bi-directional
* Auto-discovery: extract unregistered options
* Unlimited/multi level commands (eg `myapp server start ...`)
* Type conversion ('string', 'boolean', 'integer', 'array')
* Object literals: config and parsed results are serializable and human readable
* Routing: run dedicated functions or modules based on user commands
* Auto generated help
* Complete tests coverages plus samples

## Usage

The parameters package is made available to your module with the declaration
`parameters = require('parameters');`. The returned variable is a function
expecting a definition object and returning the following functions:

* `help` (command[string|null])   
  Returned a string with the complete help content or the content of a single 
  command if the command argument is passed.
* `parse` (argv[array|process])   
  Transform an array of arguments into a parameter object. If null
  or the native `process` object, the first two arguments (the node
  binary and the script file) are skipped.
* `load` (module[string])   
  Internal function used to load modules, see the "load" option to pass a
  function or a module referencing the function.
* `run` (argv[array|process], args[mixed]...)   
  Similar to parse but it will also call the function defined by the "run"
  option. The first argument is the arguments array to parse, other arguments
  are simply transmitted to the run function or module as additionnal arguments.
  The run function provided by the user receives the parsed parameters as its
  first argument. If the option "extended" is activated, it also receives the
  original arguments and configuration as second and third   arguments. Any user
  provided arguments are transmitted as is as additionnal arguments.
* `stringify` (params[obj], options[obj])   
  Convert an object of parameters into an array of arguments. Possible options
  are "no_default".

## Definition

The parameter definition is an object passed as an argument to the function exported by
this package.

The root properties are:

* `commands` (object)   
  Group the parameters into a specific command. Support object and array notation. If
  defined as an object, keys correpond to the "name" properties. If defined as 
  an array, the "name" property is required.
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
* `options` (object|array)
  Defined the expected command parameters. Support object and array notation. If
  defined as an object, keys correpond to the "name" properties. If defined as 
  an array, the "name" property is required.

The properties for options are:

* `default` (anything)   
  Default value if none is provided; always part of the object return by parse,
  part of the arguments returned by stringify unless the "no_default" option is 
  set.
* `extended` (object)   
  Used with 'run', inject the parsed parameter, the original argv array and
  the configuration as first arguments before passing the user arguments,
  default is "false".
* `main` (object)   
  Anything left which is not a parameter at the end of the arguments.
* `name` (string)   
  The name of the option, required.
* `one_of` (array)   
  A list of possible and accepted values.
* `required` (boolean)   
  Whether or not this option must always be present.
* `run` (function|string)   
  Execute a function or the function returned by a module if defined as a 
  string, provide the params object as first argument and pass the returned
  value.
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

From a user perspective, help can be displayed with two method, either with the
`--help` option or with the `help` command.

The `help` command is only available if other commands are registered in the
configuration.

Here's how ot display the help usage of the overall application.

```
./myapp --help
```

if some commands are registered, you could also use this alternative:

```
./myapp help
```

To display the help usage of a specific `hello` command, those two alternatives
are equivalent:

```
# Option
./myapp command --help
# Command
./myapp help command
```

By default, help is display to `stdout` when calling `parse`. It is possible to
to disable this behavior by setting the `help` option to "false". Also, the 
`help` option can be set to any [Node.js Writable Streams][ws].

```javascript
if(params = parameters(my_config).parse({help: true})){
  // do sth
}
// Equivalant to
if(params = parameters(my_config).parse({help: process.stdout})){
  // do sth
}
```

Call the `help` function and pass no argument to retrieve the global help and
the name of a specific command.

Here's an example on how to integrate the help functionnality inside your code:

```javascript
const parameters = require('parameters')(my_config);
const params = parameters.parse()
if(commands = parameters.helping(params)){
  return process.stdout.write(parameters.help(commands));
}
// Now work with the params object
// Or call run if command routing is configured
parameters.run(params)
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

## Multi-level commands

The package can handle simple argument definitions as well as complex command
based definitions including one or multiple nested sub commands. Thus, large 
applications can group all its functionnalities into one parent CLI entry point.

Let's start with a basic application call `myapp` which deploys and manages
a web application. Using the "conf" option, our application require a 
configuration file which everry command will use. Here's the initial definition:

```
{
  "name": "myapp",
  "description": "My Web Application",
  "options": [{
    "name": "conf",
    "required": true
  }]
}
```

It will accept three commands "info" and "server". Help is automatically
available so there is no need to define it. The server command will need a pid
file which could be defined in the global configuration or through a "pid"
option. At the same level than "name" and "options", we'll enrich the definition
with a new "commands" entry:

```
{
  "commands": [{
    "name": "info"
  },{
    "name": "server",
    "options": {
      "name": "pid"
    }
  }]
}
```

Usage of the "server" command is now:
`myapp [options] server [server options]`.

We now want to defined sub command to control our server such as "start" and 
"stop". The "start" command will require an option "port". Inside the object 
defining the "server" command, we add a new "commands" entry:

```
{
  "commands": [{
    "name": "start",
    "options": {
      "name": "port",
      "required": true
    }
  },{
    "name": "stop"
  }]
}
```

Usage of the "start" command is now:
`myapp [options] server [server options] start [start options]`.

The final definition, enriched with "run" definition to route the command to
our own modules, looks like:

```
{
  "name": "myapp",
  "description": "My Web Application"
  "options": [{
    "name": "config",
    "required": true
  }],
  "commands": [{
    "name": "info",
    "run": "./lib/config"
  },{
    "name": "server",
    "options": {
      "name": "pid"
    },
    "commands": [{
      "name": "start",
      "run": "./lib/server/start"
      "options": {
        "name": "port",
        "required": true
      }
    }, {
      "name": "stop",
      "run": "./lib/server/stop"
    }]
  }]
}
```

Place the configuration inside "config.json", and create a file "index.js" at 
the root of your project which looks like:

```
config = require('./config')
require('parameters').run(config)
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

[ws]: https://nodejs.org/api/stream.html#stream_writable_streams
