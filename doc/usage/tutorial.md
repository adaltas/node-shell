---
title: Tutorial
description: How to build CLI application using Node.js Parameters.
keywords: ['parameters', 'node.js', 'cli', 'usage', 'tutorial', 'application', 'configuration']
maturity: initial
---

# Node.js Parameters tutorial

Welcome to Node.js Parameters! The goal of this tutorial is to guide you through configuring and build your first CLI application using Parameters. Starting from scratch and go on to advanced usage of its APIs. The tutorial contains following sections:

- What is Node.js Parameters?
- Getting started
- Parsing arguments
- Argument topology
- Configuring options
- Configuring commands
- Parsing and handling arguments (commands, options, main)
- Getting help
- Structuring the code with routing

## What is Node.js Parameters?

Parameters is a Node.js package published on NPM. It is a sugar to build CLI application for parsing typical unix command line arguments. 

It offers powerful features such as:
- Reversibility: parse and stringify is bi-directional
- Auto-discovery: extract unregistered options
- Unlimited multi-level commands (eg `myapp server start ...`)
- Type conversion (`string`, `boolean`, `integer`, `array`)
- Object literals: config and parsed results are serializable and human readable
- Routing: run dedicated functions or modules based on user commands
- Auto generated help

## Getting started

For users not familiar with the Node.js environment, you can follow the [official installation instructions](https://nodejs.org/en/download/) to get started and have the `node`, `npm` and `npx` command available on your system.

The `node` command execute JavaScript scripts. The `npm` command expose the NPM package manager for JavaScript. The `npx` is intended to help round out the experience of using packages from the npm registry 

Once you have installed Node, create a basic Node.js project which is called a package:

```bash
# Create a new project directory
mkdir myapp && cd myapp
# Initialise the package with skipping the questionnaire
npm init --yes
cat package.json
# Add the "parameters" dependency
npm add parameters
cat package.js | grep parameters
# Create a new script
echo 'console.log("hello")' > app.js
node app
```

The Parameters dependency is now downloaded and available inside the "./node_modules" folder. We can start coding our application by editing the "app.js" file.

## Parsing arguments

Let's consider a simple application by modifying the "app.js" file as follow

```js
// Import the "parameter" package
const parameters = require('parameters')
// Create a new instance
const app = parameters({
  main: 'hello'
})
// Parse CLI arguments
const args = app.parse()
console.log(args)
```

The "parameters" package export a function which expect to a configuration object describing your commands.

Consider the configuration as the schema or the model of your application arguments. The `main` property retrieve all the arguments which are not mapped otherwise of an application in the form of an array.

The `parse` method convert the arguments into a parameter object. You can provide your own arguments or let `parse` discover them automatically if no argument is provided like above. Node.js expose the CLI arguments with `process.argv` as an array. The first 2 arguments are the path to the node binary and the script being executed. Parameters will strip those arguments and only parse whats left.

You can now execute `node app world` and it shall print:

```js
{ hello: [ 'world' ] }
```

## Argument topology

We have explain how to use the `main` property to retrieve all the arguments but there are other types of properties. Considering a rather complex command such as:

```
node app --config "./my/repo" start --force 0.0.0.0:80
```

This CLI command is made of multiple sections.
* `application`: the overall configuration define the application.
* `command`: "start" is called a command in param and is a subset of an application. It has its own options and main properties, dissociated from the ones defined at the application level.
* `options`: both "config" and "start" are options. The "config" option is associated with a value and the "force" option is boolean indicating the presence of the option.
* `main`: whichever arguments not recognized by the parser is pushed into the "main" property.

For the sake of curiosity, configuring Parameters as:

```js
const parameters = require("parameters")
parameters({
  options: {
  	"config": {}
  },
  commands: {
  	"start": {
      main: "address",
  	  options: {
  	  	"force": {
          type: "boolean"
} } } } })
.parse()
```

leads to:

```js
{ command: [ 'start' ],
  config: './my/repo',
  force: true,
  address: [ '0.0.0.0:80' ] }
```

Let's now deep dive on options and commands.

## Configuring options

Command-line `options` are commands used to pass parameters to a program. These entries, also called command-line switches, can pass along cues for changing various settings. They follow the command name on the command line or right after the application call. `options` can be passed it two ways when prefixed with:
- `--` followed by their name.
- `-` followed by their shortcut alternative.
It is recommended using shortcuts only for the most frequently used `options`, to avoid difficulty in understanding the commands of third-party developers. 

For example, configuration with a shortcut name:

```js
const parameters = require("parameters")
parameters({
  options: {
  	"config": {
      shortcut: 'c'
} } })
.parse()
```

Now you can pass the option and its value in two ways:

```
node app --config ./my/repo
node app -c ./my/repo
```

In place of `./my/repo` can be any value, but if you don't provide it, the CLI will run into an error. And what if you need to take a control over the values, which could be passed, or to use an option as a boolean switcher without providing with any value? To do this, options have the properties:
- `default` (anything) - a default value if none is provided.
- `one_of` (array) - a list of possible and accepted values.
- `required` (boolean) - whether or not this option must always be present (false by default).
- `type` (string) - the type used to cast between a string argument and a JS value (accepted values are 'boolean', 'string', 'integer' and 'array').

To illustrate the behaviour of each let's make a basic example, but these can be used together within one `option` as well:

```js
const parameters = require("parameters")
parameters({
  options: {
    'default-opt': {
      default: 42
    },
    'select-opt': {
      one_of: [1, 2, 3, "let's go"]
    },
    'required-opt': {
      required: true
    },
    'boolean-opt': {
      type: 'boolean'
} } })
.parse()
```

Execute this application with a command like:

```
node samples/logger --required-opt present --select-opt "let's go" --boolean-opt 
```

The result of parsing will be the object like:

```
{ 'required-opt': 'present',
  'select-opt': 'let\'s go',
  'boolean-opt': true,
  'default-opt': 42 }
```

We have considered using `options` without calling `commands`. Although, any option can be corresponded with a specific command.

## Configuring commands

When you build an application with non-trivial functionality that provides more than one operation, you associate operations with commands. The Node.js Parameters allows you to flexibly configure `commands`, like building multiple levels of hierarchy or assigning own `options`.

Let's consider the power of the Parameters capability on an example of configuring an application for logging strings into a file. We define our application performs the following operations:
- appending strings of information into the end of the file
- reading the log file in direct and reverse mode
And as well, we must specify in which file the logged information should be stored.

Create the javascript file with the name "log.js" and paste following:

```js
const parameters = require('parameters')
const app = parameters({
  options: {
    'source': {
      shortcut: 's',
      default: 'log.txt'
    }
  },
  commands: {
    'append': {
      main: {
        name: 'data',
        required: true
      }
    },
    'read': {
      options: {
        'recent': {
          type: 'boolean'
} } } } } )
```

This configuration object consists:
- `source` - the option which assigns the file where to read or write a logged data, if it is not passed the default value `log.txt` will be used.
- `append` - the command for writing `data` into a log file. The `data` is the required main argument that passes strings.
- `read` - the command for reading from a log file. The option `recent` passes a boolean flag which sets the mode of reading.

## Parsing and handling arguments (commands, options, main)

In the configuration above we have prepared the model of our application. For the further handling and adding the functionality we will operate with the `args` object returned with the method `parse`, for example like this:

```js
// Parsing arguments
const args = app.parse()
// The example of handling arguments
switch(args.command[0]){
  case 'append':
    // Do something...
    break
  case 'read':
    // Do something...
    break
}
```

Let's add a logic to our logging application:

```js
// Parsing arguments
const args = app.parse()
// Use file system module
var fs = require("fs")
// Handling commands
switch (args.command[0]) {
  case 'append':
    // Appending the string to the file
    fs.appendFile(args.source, args.data + "\n", (err) => { if(err) throw err })
    break
  case 'read':
    // Reading the file
    fs.readFile(args.source, function(err, buf) {
      if(err) throw err
      if(args.recent)
        console.log('Reverse mode') // TODO reverse mode
      else
        process.stdout.write(buf.toString())
    })
    break
}
```

Now you can execute the application:

```
node log append "this is a random string"
node log append "this is a second random string"
node log read
```

The file with a name "log.txt" in you current directory will be created. The output of these commands is going to be like this:

```
this is a random string
this is a second random string
```

Another usage with the `source` option. We define the name of the file like `mylog.txt`:

```
node log -s mylog.txt append "the first string of the file mylog.txt"
node log -s mylog.txt read
```

The output is:

```
the first string of the file mylog.txt
```

### Getting help

Parameters convert the configuration object into a readable documentation string about how to use the CLI application or one of its commands. To integrate printing help uses a combination of the `helping` and `help` methods. The `helping` method takes the parsed parameters and check if printing help is requested. The `help` method return the usage information as a string:

```js
// Getting help
// Wether or not help was requested
if(commands = app.helping(args)){
  // Print a help information
  process.stdout.write(app.help(commands))
  // Terminate the process
  process.exit()
}
```

Let's add this code into the application and write the description for each of the commands and options:

```js
// Configuring application
const parameters = require('parameters')
const app = parameters({
  name: 'log',
  description: 'Log information',
  options: {
    'source': {
      shortcut: 's',
      default: 'log.txt',
      description: 'The path to a file in which the logged information are stored'
    }
  },
  commands: {
    'append': {
      description: 'Append strings to a log file',
      main: {
        name: 'data',
        required: true,
        description: 'Logged data'
      }
    },
    'read': {
      description: 'Read a log file',
      options: {
        'recent': {
          type: 'boolean',
          description: 'Reading in reverse mode'
} } } } } )
// Parsing arguments
const args = app.parse()
// Getting help
// Wether or not help was requested
if(commands = app.helping(args)){
  // Print a help information
  process.stdout.write(app.help(commands))
  // Terminate the process
  process.exit()
}
/* ... */
```

From a user perspective, to print the help information of the overall application to the console you can use the command `help`, the option `--help` or its shortcut `-h`. 

```
node log help
node log --help
node log -h
```

It prints a human readable text divided into the following sections:
- "NAME" - the short description of the application or the command
- "SYNOPSIS" - the basic syntax for using the command and its options
- "OPTIONS" - the description of each option
- "COMMANDS" - the description of each command
- "EXAMPLES" - the usage of the command and its options

```
NAME
    log - Log information

SYNOPSIS
    log [log options] <command>

OPTIONS
    -s --source             The path to a file in which the logged information are stored
    -h --help               Display help information

COMMANDS
    append                  Append strings to a log file
    read                    Read a log file
    help                    Display help information about log

EXAMPLES
    log --help              Show this message
    log help                Show this message
```

To print the help information of the specific commands use a command name after the `help` command, for example, `node log help read`. It prints a list of options of the application and any parent command as well.

```
NAME
    log read - Read a log file

SYNOPSIS
    log [log options] read [read options]

OPTIONS for read
    --recent                Reading in reverse mode
    -h --help               Display help information

OPTIONS for log
    -s --source             The path to a file in which the logged information are stored
    -h --help               Display help information

EXAMPLES
    log read --help         Show this message
```

The `help` option is automatically registered to the application as well as to every commands. So, the same result as the above can be achieved with these commands:

```
node log read --help
node log read -h
```

## Structuring the code with routing

We can build very simple CLI application using only one file like we made above. When the application is getting complex, the best practice is to load and configure the router in a separate top-level module that is dedicated to routing. 

Considering the "log" application containing the "append" and the "read" commands, each commands will define a `route` function. We will refactor it according to this project structure:

```
/
|-- /node-modules
|-- /routes
    |-- append.js
    |-- read.js
|-- log.js
|-- package.json
|-- package-lock.json
```

To configure routing you need to define the `route` property for the `commands`. The value of this property should be as a function or the function exported by a module if defined as a string:

```js
const parameters = require('parameters')
const app = parameters({
  /* ... */
  commands: {
    'append': {
      /* ... */
      route: './routes/append.js'
    },
    'read': {
      /* ... */
      route: './routes/read.js'
    }
  }
})
```

To execute routing you need to call the `route` method, which dispatch the commands of the CLI application into a function based on the `route` configuration property of the commands:

```js
app.route()
```

The `route` method receives as first argument a context object with the following properties:
- `argv` - the CLI arguments, either passed to the `route` method or obtained from `process.argv`
- `params` - the parameters object derived from `argv`
- `config` - the configuration object used to initialise the parameters instance

Let's create the files with modules which will export functions "append" and "read".
The content of the file `./routes/append.js`:

```js
module.exports = function ({argv, params, config}) {
  // Use file system module
  var fs = require("fs")
  // Appending the string to the file
  fs.appendFile(params.source, params.data + "\n", (err) => {
    if(err) throw err
  })
}
```

The content of the file `./routes/read.js`:

```js
module.exports = function ({argv, params, config}) {
  // Use file system module
  var fs = require("fs")
  // Reading the file
  fs.readFile(params.source, function(err, buf) {
    if(err) throw err
    if(params.recent)
      console.log('Reverse mode') // TODO reverse mode
    else
      process.stdout.write(buf.toString())
  })
}
```

Notice, when using routing we don't need to take care about the parsing and calling the help, it is implemented inside the `route` method. The top-level module of the CLI application, which is the "log.js" file, will look like:

```js
const parameters = require('parameters')
const app = parameters({
  name: 'log',
  description: 'Log information',
  options: {
    'source': {
      shortcut: 's',
      default: 'log.txt',
      description: 'The path to a file in which the logged information are stored'
    }
  },
  commands: {
    'append': {
      description: 'Append strings to a log file',
      main: {
        name: 'data',
        required: true,
        description: 'Logged data'
      },
      route: './routes/append.js'
    },
    'read': {
      description: 'Read log file',
      options: {
        'recent': {
          type: 'boolean',
          description: 'Reading in reverse mode'
        }
      },
      route: './routes/read.js'
    }
  }
})
app.route()
```
