---
title: Tutorial
description: How to build CLI application using parameters.
keywords: ['parameters', 'node.js', 'cli', 'usage', 'tutorial', 'application', 'configuration']
maturity: initial
---

# Node.js Parameters tutorial

## Introduction

This tutorial covers the basics of using the Node.js Parameters package. It contains 4 sections:

- What is Parameters?
- Getting started
- Parsing arguments
- Argument topology

Starting from scratch and go on to advanced usage of its APIs.

## What is Parameters?

Parameters is a Node.js package published on NPM to build CLI application. At its core, it parses command line arguments. It also offers powerful features such as:
- Reversibility: parse and stringify is bi-directional
- Auto-discovery: extract unregistered options
- Unlimited/multi level commands (eg `myapp server start ...`)
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

The parameters dependency is now downloaded and available inside the "./node_modules" folder. We can start coding our application by editing the "app.js" file.

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

## Configuring an example application using commands

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
// Use file system module
var fs = require("fs");
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
    });
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

------------------

### Getting help

Enabling help in the application

```js
if(commands = app.helping(args)){
  process.stdout.write(app.help(commands))
}
```

Now you can get help:

```
node app -h
```

If the configuration contains commands you can get help for the specified command:

```
{
  commands: {
    'start': {
      description: 'Start something.',
    },
  },
}
```

```
node app help start 
```

[Read more](/api/help/) about the help API.

### Structuring the code with routing

Example of refactoring of the application.
