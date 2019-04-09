---
title: Extended mode usage
description: How to use the extended mode.
keywords: ['parameters', 'node.js', 'cli', 'usage', 'extended', 'mode']
maturity: review
---

# Flatten versus extended mode

For the sake of simplicity, the module operates by default in flatten mode. When parsing application arguments without sub commands, it doesn't make much a difference. However, when the application grew and more commands with deepest levels are created, there is a risk of collision between multiple options registering the same properties. While being a little more verbose, the extended ensure that multi levels of options and main arguments can be defined with the same property name.

## Examples

For example, consider an application which register a "config" property for the overall application as well as a `start` command:

```js
require("parameters")({
  options: {
    "config": {}
  },
  commands: {
    "start": {}
  }
})
```

The overall application can be started with the command `./myapp --config ./config.yml start` and its parameters in flatten mode will parsed like:

```json
{ "command": ["start"],
  "config": "./config.yml" }
```

However, let's imaging that we need to add a new option to provide a configuration specific to the start command. Declaring a new "config" option will throw an error "Invalid Option Configuration: ..." in the default flatten mode to prevent collision from happening. 
