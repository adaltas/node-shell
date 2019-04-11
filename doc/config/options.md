---
title: Options configuration
description: How to define options
keywords: ['parameters', 'node.js', 'cli', 'usage', 'options']
maturity: review
---

# Options

## Description

Options define the arguments passed to a shell scripts when prefixed with `--` followed by their name or `-` followed by their shortcut alternative.

## Properties

* `default` (anything)   
  Default value if none is provided; always part of the object return by parse,
  part of the arguments returned by [`stringify`](/api/stringify/) unless the "no_default" option is set.
* `name` (string)   
  The name of the option, required.
* `one_of` (array)   
  A list of possible and accepted values.
* `required` (boolean)   
  Whether or not this option must always be present.
* `route` (function|string)   
  Execute a function or the function exported by a module if defined as a 
  string, provide the params object, see the [routing documentation](/usage/routing/).
* `shortcut` (char)   
  Single character alias for the option name.
* `type` (string)   
  The type used to cast between a string argument and a JS value, not all types 
  share the same behaviour. Accepted values are 'boolean', 'string', 'integer'
  and 'array'.

## Examples of configuration

When option is defined as an object, the keys are mapped to the option name. For example, an option `message` with an shortcut `m` is defined as:

```js
require("parameters")(
{ options:
  { message:
    { shortcut: "m" } } }
)
```

The above is the equivalent of declaring options as an array like:

```js
require("parameters")(
{ options: [
  { name: "message",
    shortcut: "m" } ] }
)
```

Options may apply to the [application](./) like in the above or to the [command](./commands/) like below:

```js
require("parameters")(
{ commands:
  { print:
    { options: 
      { name: "message",
        shortcut: "m" } } } }
)
```
