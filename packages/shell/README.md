
# Shell.js argument parser and router for Node.js

This project demonstrates the usage of the Shell library for creating command-line tools that parse arguments and route function calls based on those arguments. The Shell library uses a declarative syntax and allows you to build powerful and user-friendly command-line interfaces in Node.js.

Please start the [tutorial](https://shell.js.org/usage/tutorial/) and refer to the [project website](https://shell.js.org/) to access the documentation.

## Features

- Argument parser and stringifier (reversability)
- Declarative syntax
- Commands and sub-commands support
- Routing and asynchronous function call
- Auto generate help

## Prerequisites

- Node.js (version 18 or later)
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
    "config": {
      shortcut: "c",
      description: "Some option"
    }
  },
  commands: {
    "start": {
      description: "Start something"
    }
  }
})
.route();
```
