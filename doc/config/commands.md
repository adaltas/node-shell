---
title: Commands
description: How to define commands
keywords: ['parameters', 'node.js', 'cli', 'usage', 'commands']
maturity: review
---

# Commands

## Description

Commands define the arguments passed to a shell scripts.

## Properties

* `name` (string)   
  The command name.
* `description` (string)   
  The command description.
* `options` (object|array)   
  Defined the expected command parameters. Support object and array notation. If
  defined as an object, keys correspond to the "name" properties. If defined as 
  an array, the "name" property is required.
  
## Multi-level commands

The package can handle simple argument definitions as well as complex command
based definitions including one or multiple nested sub commands. Thus, large 
applications can group all its functionalities into one parent CLI entry point.

## Examples of configuration

### Basic application

Let's start with a basic application call `myapp` which deploys and manages
a web application. Using the "conf" option, our application require a 
configuration file which every command will use. 

Here's the initial definition:

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

### Multiple commands

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

### Subcommands

We now want to defined subcommand to control our server such as "start" and 
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

### With routing

The final definition, enriched with "route" definition to route the command to
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
    "route": "./lib/config"
  },{
    "name": "server",
    "options": {
      "name": "pid"
    },
    "commands": [{
      "name": "start",
      "route": "./lib/server/start"
      "options": {
        "name": "port",
        "required": true
      }
    }, {
      "name": "stop",
      "route": "./lib/server/stop"
    }]
  }]
}
```
