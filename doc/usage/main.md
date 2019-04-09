---
title: Main parameter usage
description: How to use main parameter.
keywords: ['parameters', 'node.js', 'cli', 'usage', 'main']
maturity: review
---

# Main parameter

Main is what is left once the option and the commands have been extracted. 
Like options, "main" is defined at the "config" level or for each command.

## Configuration

```js
require("parameters")(
{ main: "leftover" }
)
```

The above is the equivalent of declaring options as an array like:

```js
require("parameters")(
{ main:
  { name: "leftover" } }
)
```

### In a command

TODO: describe how main could be configured in a command.
