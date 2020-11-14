---
title: Main parameter usage
description: How to use main parameter.
keywords: ['parameters', 'node.js', 'cli', 'usage', 'main']
maturity: initial
---

# Main

## Description

Main is what is left once the option and the commands have been extracted. Like with `options`, the `main` property is defined at the application level or for each command.

## Definition

The `main` property is declared as an object with the following properties:

* `name` (string)   
  The name of the main property.
* `required` (boolean)   
  Whether or not the value must always be present.
* `description` (string)   
  The description of the main argument.

As an alternative, a "string" can also be provided which will be converted to an object with the name property set to the original string value. Thus, the following declarations are equivalent:

```js
parameters({
  main: 'input'  
})
// is equivalent to
parameters({
  main: {
    name: 'input' 
  } 
})
```

The extracted value is an array.

If [no main arguments](https://github.com/adaltas/node-parameters/blob/master/samples/main_empty.js) is defined in the CLI commands, then the array is empty.

```js
require('should')
require('parameters')({
  main: 'input' 
})
.parse([])
.should.eql({
  input: []
})
```

## Examples

## Application level definition

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

## Command level definition

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
