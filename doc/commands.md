
# Multi-level commands

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
