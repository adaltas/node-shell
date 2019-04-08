
# Changelog

## Trunk

Breaking compatibility
* run: 1st arg as info with params and extended
* help: only accept a command, no params
* route: rename run method and configuration to route
* helping: only accept params, no more argv

New functionality
* extended: parse and stringify without merging
* main: string declaration shortcut
* parse: main as an array
* stringify: main from an array

Fix and improvements
* configure: isolate into its own method
* options: prevent collisions in flatten mode
* help: new extended option
* helping: complete re-implementation
* stringify: check 2nd argument
* help: new sample
* help: remove info per command
* package: use mixme
* parse: new extended option
* parse: improve arguments validation
* command: only declared at application level
* license: switch to MIT license
* package: use file instead of npm ignore

## Version 0.4.4

* one_of: handle optional params
* lib: move load & merge to utils
* readme: add author company
* package: relative paths

## Version 0.4.3

* help: accept array as first argument
* src: fix error thrown as string instead of object

## Version 0.4.2

* help: overwrittable by user

## Version 0.4.1

* help: handle shortcut
* shortcut: improve err message
* config: root property for internal use

## Version 0.4.0

* run: route help options and command
* src: convert to literate coffee
* helping: new function
* help: new revisited format supporting nested commands
* commands: unlimited nested dimensions
* doc: improve run description
* run: user arguments as last arguments, new extended option

## Version 0.3.0

* help: default app name and description
* config: options and commands as objects literals

## Version 0.2.2

* load: custom user module loader

## Version 0.2.1

* commands: default to help fixed on presence of options
* run: error handling for humans

## Version 0.2.0

* package: release commands
* package: update Node.js version inside Travis
* parse: better error handling
* options: new default option
* test: should required by mocha
* help: fix shortcut in commands
* options: run get context, argv and config
* options: run options accepts a function or a module
* readme: API documentation
* package: upgrade to CoffeeScript 2
