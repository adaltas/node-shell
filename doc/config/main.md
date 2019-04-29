---
title: Main parameter usage
description: How to use main parameter.
keywords: ['parameters', 'node.js', 'cli', 'usage', 'main']
maturity: initial
---

# Main

## Description

Main is what is left once the option and the commands have been extracted. 
Like options, "main" is defined at the "config" level or for each command.

## Properties

* `name` (string)   
  The name of the main property.
* `required` (boolean)   
  Whether or not the value must always be present.
* `description` (string)   
  The description of the main argument.
  
## Examples of configuration

### In the root property

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

Usage of the "main" parameter is now:
`myapp [leftover]`.

### In a command

```js
require("parameters")(
{ commands: [
  { name: 'server'
    main: 'leftover' } ] }
)
```

Usage of the "main" parameter is now:
`myapp server [leftover]`.


### In multi-level commands

```js
require("parameters")(
{ commands: [
  { name: 'server'
  commands: [
    { name: 'start'
      main: 'leftover' } ] } ] }
)
```

Usage of the "main" parameter is now:
`myapp server start [leftover]`.
