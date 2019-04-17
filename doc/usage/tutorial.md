---
title: Tutorial
description: How to build CLI application using parameters.
keywords: ['parameters', 'node.js', 'cli', 'usage', 'tutorial', 'application', 'configuration']
maturity: initial
---

# Node.js Parameters tutorial

## Introduction

**what you will learn, what do final app will achieve**

This tutorial covers the basics of using the Node.js Parameters package. It contains 4 sections:

- What is Parameters?
- Getting ready
- Configuring application
- Real life example

Starting from scratch and go on to advanced usage of its APIs.

## What is Parameters?

Parameters is a Node.js package published on NPM to build CLI application. At its core, it parses command line arguments. It also offer powerful features such as ...
**It can be useful for building your own CLI ...**

## Getting started

**Download and install Node.js, initialise your project**

For users not familiar with the Node.js environment, you can follow the [official installation instructions](https://nodejs.org/en/download/) to get started and have the `node`, `npm` and `npx` command available on your system.

The `node` command execute JavaScript scripts. The `npm` command expose the NPM package manager for JavaScript. The `npx` is intended to help round out the experience of using packages from the npm registry 

Once you have installed Node, create a basic Node.js project which is called a package:

```bash
# Create a new project directory
mkdir myapp && cd myapp
# Initialise the package
npm init
cat package.json
# Add the "parameters" dependency
npm add parameters
cat package.js | grep parameters
# Create a new script
echo 'console.log("hello")' > app.js
node app
```

The parameters dependency is now downloaded and available inside the "./node_modules" folder. We can start coding our application by editing the "app.js" file.

### Parsing arguments

**load parameters, pass a simple configuration using declarative style and run it**

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

The `parse` method convert the arguments into a parameter object. You can provide your own arguments or let `parse` discover them automatically if no argument is provided like above. Node.js expose the CLI arguments with `process.argv`  as an array. The first 2 arguments are the path to the node binary and the script being executed. Parameters will strip those arguments and only parse whats left.

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
* `command`: "reset" is a called a command in param and is a subset of an application. It has its own options and main properties, dissociated from the ones defined at the application level.
* `options`: both "config" and "hard" are options. The "deamonize" option is associated with a value and the "hard" option is boolean indicating the presence of the option.
* `main`: whichever arguments not recognized by the parser is pushed into the "main" property.

For the sake of curiosity, Configuring Parameters as:

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

leads to

```js
{ command: [ 'start' ],
  config: './my/repo',
  force: true,
  address: [ '0.0.0.0:80' ] }
```

Let's now deep dive on options and commands.

### Adding options

Simple configuration.

```js
const parameters = require('parameters')

const app = parameters({
  options: {
    'source': {
      description: 'Path to the log file'
    },
  },
})

const args = app.parse()

if(args.source){
  console.log('Option source: ' + args.source)
}
```

Usage:

```
node myapp.js --source ./mypath/file.txt
```

You will get:

```
Option source: ./mypath/file.txt
```

Configuring options with shortcuts:

```js
{ 
  options: {
    'source': {
      description: 'Path to the log file',
      shortcut: "s",
    }
  } 
}
```

Usage:

```
node myapp.js -s ./mypath/file.txt
```

Limitations of option values:

```js
{ 
  options: {
    'number': {
      type: 'integer'
    }
  } 
}
```

```js
{ 
  options: {
    'format': {
      one_of: ['json', 'yaml'],
      required: true,
    }
  } 
}
```

[Read more](/config/options/) about how to configure options.

### Using commands

Basic example:

```js
const parameters = require('parameters');

const app = parameters({
  commands: {
    'start': {
      description: 'Start something',
    },
  },
})

const args = app.parse()

switch (args.command[0]) {
  case 'start':
    console.log('Command start')
    break
}
```

Usage:

```
node myapp.js start
```

You will get:

```
Command start
```

Commands with options:

```js
{
  commands: {
    'server': {
      description: 'Start server.',
      options: {
        'host': {
          shortcut: 'h',
          description: 'Web server listen host',
        },
        "port": {
          shortcut: 'p',
          type: "integer",
          description: "Web server listen port" } },
      }
    },
  },
}
```

Usage:

```
node myapp.js start -h 127.0.0.1 -p 8080
```

Refactoring to add sub commands

```js
{
  commands: {
    'server': {
      description: 'Server root command.',
      commands: {
        'start': {
          description: 'Start server.',
          options: {
            'host': {
              shortcut: 'h',
              description: 'Web server listen host',
            },
            "port": {
              shortcut: 'p',
              type: "integer",
              description: "Web server listen port" } },
          },
        "stop": {
           description: 'Stop server.',
         }
        },
      },
    },
  },
}
```

[Read more](/config/commands/) about how to configure commands.

### Getting help

How to enable help in the application

```js
const parameters = require('parameters');

const app = parameters({
  name: 'myapp',
  description: 'My pretty application',
  options: {
    'source': {
      description: 'This is the source option',
      shortcut: 's',
    },
  },
})

const args = app.parse()

if(commands = app.helping(args)){
  process.stdout.write(app.help(commands))
}
```

Now you can get help:

```
node myapp.js -h
```

or

```
node myapp.js --help
```

**output**

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
node myapp.js help start 
```

**output**


[Read more](/api/help/) about the help API.

### Structuring the code with routing

Example of refactoring of application (server start/stop) 

## Real life example

We will consider an example of a simple logging application with a minimum of specific tasks, 
which appends the string into the end of file.

### Configuring application

Create the javascript file with the name for example "logger.js".

The config of parameters package will look like:

```js
const parameters = require('parameters');
...
```

### Passing arguments (commands, options, main)

Now we can pass arguments taken from the command line and parse them for the further handling:

```js
const params = app.parse()

switch(params.command[0]){
  case 'append':
    console.log('Command append')
    break
}
```

### Adding some logic

Let's add a logic to our application:

```js
switch(params.command[0]){
  case 'append':
    console.log('Command append')
    break
}
```

### Refactoring with routing


### Getting help

### Testing and usage

```
node path-to/myapp.js append 'banana'    // Command add
```
