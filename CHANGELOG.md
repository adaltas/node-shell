# Change Log

All notable changes to this project will be documented in this file.
See [Conventional Commits](https://conventionalcommits.org) for commit guidelines.

## [0.9.2](https://github.com/adaltas/node-shell/compare/v0.9.1...v0.9.2) (2022-02-24)


### Bug Fixes

* add let/const to variables ([dd175ff](https://github.com/adaltas/node-shell/commit/dd175ff43070efa30d5d3e06720e1ce05978185a))
* commit lint config and comment coffee lint ([719e3c2](https://github.com/adaltas/node-shell/commit/719e3c240ae3eba547adb059f67dae062effaae6))
* **shell:** throw error unless commands an object ([96ef828](https://github.com/adaltas/node-shell/commit/96ef828405f67843b19921f5da8bfb149d571702))





## [0.9.1](https://github.com/adaltas/node-shell/compare/v0.9.0...v0.9.1) (2022-02-17)


### Bug Fixes

* **router:** handle undefined with config promise ([e4f04a4](https://github.com/adaltas/node-shell/commit/e4f04a4cad01c74a4f08bf410f80355f0374b599))





# [0.9.0](https://github.com/adaltas/node-shell/compare/v0.8.6...v0.9.0) (2022-02-16)


### Features

* **router:** promise config ([78369f3](https://github.com/adaltas/node-shell/commit/78369f3610ac44cedd7214d32e7e1c42a736e042))





## [0.8.6](https://github.com/adaltas/node-shell/compare/v0.8.5...v0.8.6) (2022-01-06)


### Bug Fixes

* **shell:** multi level default option ([cdaaa9b](https://github.com/adaltas/node-shell/commit/cdaaa9b71d8e0a161f8df4f22fec86d39e8b8d11))





## [0.8.5](https://github.com/adaltas/node-shell/compare/v0.8.4...v0.8.5) (2021-12-02)


### Bug Fixes

* **shell:** prevent main collision with command ([2a72240](https://github.com/adaltas/node-shell/commit/2a72240d19cca1925bae2b5cb85006cf163b9452))





## [0.8.4](https://github.com/adaltas/node-shell/compare/v0.8.3...v0.8.4) (2020-12-09)

**Note:** Version bump only for package shell





## [0.8.3](https://github.com/adaltas/node-shell/compare/v0.8.2...v0.8.3) (2020-12-07)

**Note:** Version bump only for package shell





## [0.8.2](https://github.com/adaltas/node-shell/compare/v0.8.1...v0.8.2) (2020-12-07)


### Features

* **router:** pass context stdin ([17b5f4a](https://github.com/adaltas/node-shell/commit/17b5f4aa34c050f16eba4fe3cd51393584aac823))





## [0.8.1](https://github.com/adaltas/node-parameters/compare/v0.8.1-alpha.5...v0.8.1) (2020-11-24)


### Bug Fixes

* **grpc_client:** c++ version now optional ([28b4f32](https://github.com/adaltas/node-parameters/commit/28b4f322423a66c51681b55d75c9b96cf80d3a29))
* **grpc_server:** c++ version now optional ([0584565](https://github.com/adaltas/node-parameters/commit/058456518619fc71af001891935a02a518da6096))





## [0.8.1-alpha.5](https://github.com/adaltas/node-parameters/compare/v0.8.1-alpha.4...v0.8.1-alpha.5) (2020-11-23)


### Bug Fixes

* setup Husky ([2a56ee2](https://github.com/adaltas/node-parameters/commit/2a56ee2b4104564bccb094452f2d63af21d9554c))





## [0.8.1-alpha.4](https://github.com/adaltas/node-parameters/compare/v0.8.1-alpha.3...v0.8.1-alpha.4) (2020-11-23)


### Bug Fixes

* **grpc:** readme for client and server ([19c830a](https://github.com/adaltas/node-parameters/commit/19c830a98762a9926adce63ad2f301e11824c4ca))
* **grpc:** remove unused shell proto file ([35b3cdd](https://github.com/adaltas/node-parameters/commit/35b3cdddb183dc988da780ffcff1b7ed2b49a3c7))





## [0.8.1-alpha.3](https://github.com/adaltas/node-parameters/compare/v0.8.1-alpha.2...v0.8.1-alpha.3) (2020-11-23)

**Note:** Version bump only for package parameters





## [0.8.1-alpha.2](https://github.com/adaltas/node-parameters/compare/v0.8.1-alpha.1...v0.8.1-alpha.2) (2020-11-23)

**Note:** Version bump only for package parameters






# Changelog

## TODO

* rename commands into actions
* describe the anatomy of a command

## Trunk

* monorepos

## Version 0.8.0

* help: print main before options
* help: new columns and one_column options
* help: new indent option, default to 2 spaces
* enum: renamed from one_of
* options: required as a function
* main: required as a function
* utils: isolate all utils
* router: rename route property to handler

## Version 0.7.4

* main: default to empty array
* router: promise example
* router: split writer to stdout and stderr
* types: validate integer option is not NaN
* router: route no longer accept process
* router: remove end property

## Version 0.7.3

* docs: typos

## Version 0.7.2

* package: update author url

## Version 0.7.1

* options: enforce literal object

## Version 0.7.0

Backward incompatibilities
* help: remove help command inject in non leaf commands
* parse: dont accept string command, only [string] and process
* commands: only accept objects, no arrays
* options: only accept objects, no arrays
* compile: rename stringify method to compile

New functionality
* options: new disabled property
* help: new plugin
* help: sort options
* router: accept a context object
* router: rename root property help to router
* router: new router_call hook
* hook: return value from handler
* hook: configure_app_set hook
* hook: configure_commands_set hook
* hook: new plugin/hook system
* config: dsl api plugin
* project: plugin architecture

Fix and improvements
* configure: persist name collision store

## Version 0.6.0

New functionality
* router: redirect error to help route
* router: handle help options and commands

Fix and improvements
* configure: immutable input
* project: normalise error messages
* options: fix collision detection for sibling commands
* shortcut: no need to test in strict mode

## Version 0.5.0

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
* parse: new extended option
* parse: improve arguments validation
* command: only declared at application level

Management
* license: switch to MIT license
* package: use mixme
* package: use file instead of npm ignore
* package: latest package dependencies

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
