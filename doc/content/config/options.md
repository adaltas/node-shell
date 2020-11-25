---
title: Options configuration
description: How to define options
keywords: ['shell', 'node.js', 'cli', 'usage', 'options']
maturity: review
---

# Options

## Description

Options define the arguments passed to a shell scripts when prefixed with `--` followed by their name or `-` followed by their shortcut alternative.

## Properties

* `default` (anything)   
  Default value if none is provided; always part of the object return by parse,
  part of the arguments returned by [`compile`](/api/compile/) unless the "no_default" option is set.
* `disabled` (boolean, optional, false)   
  Disabled an option.
* `name` (string)   
  The name of the option, required.
* `enum` (array)   
  A list of possible and accepted values.
* `required` (boolean || function)   
  Whether or not this option must always be present.
* `shortcut` (char)   
  Single character alias for the option name. Shortcuts must always be declared in the configuration and will not be automatically be extracted like options are when the "strict" property is not enabled.
* `type` (string)   
  The type used to cast between a string argument and a JS value, not all types 
  share the same behaviour. Accepted values are 'boolean', 'string', 'integer'
  and 'array'.
* `description` (string)   
  The description of the option.

## Using `required` as a function

When `required` is a function, the first argument is an object with the following properties:

* `config`   
  The configuration associated with the command or the full configuration is no command is used.
* `command`
  The current command name, use `config.command` to acess the full command as an array.

## Examples of configuration

When option is defined as an object, the keys are mapped to the option name. For example, an option `message` with a shortcut `m` is defined as:

```js
require("shell")({
  options: {
    "message": {
      shortcut: "m"
}}})
```

Options may apply to the [application](./) like in the above or to the [command](./commands/) like below:

```js
require("shell")({
  commands: {
    print: {
      options: {
        "message": {
          shortcut: "m"
}}}}})
```
