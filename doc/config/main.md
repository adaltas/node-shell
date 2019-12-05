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

## Definition

The `main` parameter is defined at the application and at the command level. It is an object with the following properties:

* `name` (string)   
  The name of the main property.
* `required` (boolean)   
  Whether or not the value must always be present.
* `description` (string)   
  The description of the main argument.

As an alternative, a "string" can also be provided which will be converted to an object with the name property set to the original string value.
  
## Example definition at the application level

```js
require("parameters")({
  main: "leftover"
})
```

The above is the equivalent of declaring options as an array like:

```js
require("parameters")({
  main: {
    name: "leftover"
}})
```

Usage of the "main" parameter is now: `myapp [leftover]`.

## Example definition at the command level

```js
require("parameters")({
  commands: [{
    name: 'server',
    commands: [{
      name: 'start',
      main: 'leftover'
}]}]})
```

Usage of the "main" parameter is now: `myapp server start [leftover]`.
