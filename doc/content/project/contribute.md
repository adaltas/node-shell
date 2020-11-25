---
title: Contribution
description: How to contribute to the project.
keywords: ['shell', 'node.js', 'cli', 'development', 'test', 'contributors', 'contribute']
maturity: review
---

# Contribution

## Introduction

You are encouraged to contribute to Shell.js. The project is open sourced under the MIT license and it is hosted on [GitHub](https://github.com/adaltas/node-shell). It is written and maintained by [Adaltas](https://www.adaltas.com/), a consulting company based in Paris which specialized in Big Data.

Contributions go far beyond pull requests and commits. We are thrilled to receive a variety of other contributions including the following:

* Write and publish your own actions
* Write articles and blog posts, create tutorial and spread the words
* Submit new ideas of features and documentation
* Submitting documentation updates, enhancements, designs, or bugfixes
* Submitting spelling or grammar fixes
* Additional unit or functional tests
* Help answering questions and issues on GitHub

## Development

Tests are executed with mocha. To install it, simple run `npm install`, it will
install mocha and its dependencies in your project "node_modules" directory.

To run the tests:

```bash
npm test
```

The tests run against the CoffeeScript source files.

To generate the JavaScript files:

```bash
npm run build
```

The test suite is run online with [Travis](https://travis-ci.com) against the supported 
Node.js versions.

## Contributors

*   David Worms: <https://github.com/wdavidw>
*   Sergei Kudinov: <https://github.com/sergkudinov>

This package is developed by [Adaltas](http://www.adaltas.com).
