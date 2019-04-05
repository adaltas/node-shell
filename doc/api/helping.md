---
title: API method `helping`
description: How to use the `helping` method to determine if help was requested.
keywords: ['parameters', 'node.js', 'cli', 'api', 'help', 'print']
maturity: initial
---

# Method `helping(params)`

Determine if help was requested by returning zero to n commands if help is requested or null otherwise.

* `params`: `[object] | object` The parameter object parsed from arguments, an object in flatten mode or an array in extended mode, optional.
* Returns: `array | null` The formatted help to be printed.
