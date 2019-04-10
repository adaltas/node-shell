---
title: Commands configuration
description: How to define commands
keywords: ['parameters', 'node.js', 'cli', 'usage', 'commands']
maturity: review
---

# Commands

Commands define the arguments passed to a shell scripts.

## Multi-level commands

The package can handle simple argument definitions as well as complex command
based definitions including one or multiple nested sub commands. Thus, large 
applications can group all its functionalities into one parent CLI entry point.

## Examples

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

### Sub commands

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

## JSON configuration

Place the configuration inside "config.json", and create a file "index.js" at 
the root of your project which looks like:

```
config = require('./config')
require('parameters').route(config)
```
