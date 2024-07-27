# Shell.js argument parser and router for Node.js

This project demonstrates the usage of the Shell library for creating command-line tools that parse arguments and route function calls based on those arguments. The Shell library uses a declarative syntax and allows you to build powerful and user-friendly command-line interfaces in Node.js.

Please start the [tutorial](https://shell.js.org/usage/tutorial/) and refer to the [project website](https://shell.js.org/) to access the documentation.

## Features

- Reversibility, argument parser and stringifier
- Auto-discovery, extract unregistered options
- Standard and commands-based command lines (eg `git pull ...`)
- Unlimited/multi level commands (eg `myapp server start ...`)
- Type conversion ('string', 'boolean', 'integer', 'array')
- Object literals, config and parsed results are serializable and human readable
- Routing, run asynchronous functions or modules based on user commands
- Auto-generated help
- Complete tests coverages and samples

## Prerequisites

- Node.js (version 20 or later)
- A Node Package Manager

## Installation

To use Shell.js in your project, you need to install it.

```sh
npm install shell
```

The package export the `shell` function.

```js
import { shell } from "shell";

shell({
  name: "myapp",
  description: "My CLI application",
  options: {
    config: {
      shortcut: "c",
      description: "Some option",
    },
  },
  commands: {
    start: {
      description: "Start something",
    },
  },
}).route();
```
