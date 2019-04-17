---
title: Tutorial
description: How to build CLI application using parameters.
keywords: ['parameters', 'node.js', 'cli', 'usage', 'tutorial', 'application', 'configuration']
maturity: initial
---

# Node.js Parameters tutorial

## Introduction

**what you will learn, what do final app will achieve**

This tutorial covers the basics of using Node.js Parameters. 
It contains 4 sections:
- What is Parameters?
- Getting ready
- Configuring application
- Real life example

Starting from scratch and go on to advanced usage of its APIs.

## What is Parameters?

Parameters is a Node.js package hosted on NPM which is used as for parsing typical unix command line arguments.
**It can be useful for building your own CLI ...**

## Getting ready

**Where to get, how to install node.js**
Once you have installed Node, create a basic Node.js project:

```
mkdir myapp
cd myapp
npm init
npm add parameters
touch app.js
```

The parameters dependency is now downloaded and available inside the "./node_modules" folder. We can start coding our application by editing the "myapp.js" file.

## Configuring application

### Initialisation

**load parameters, pass a simple configuration using declarative style and run it**
  
We will start with a simple configuration for parameters package.
Where we initialize option which take the name of...

```js
const parameters = require('parameters');

const app = parameters({
  name: 'myapp',
  description: 'My pretty application',
  main: 'source',
})

const args = app.parse()

console.log(args.source)
```

### Adding options

Simple configuration.

```js
const parameters = require('parameters');

const app = parameters({
  options: {
    'source': {
      description: 'Path to the log file',
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
