---
title: Routing
description: Route commands to individual handler functions.
keywords: ['parameters', 'node.js', 'cli', 'usage', 'routing', 'route', 'handler', 'fucntion']
maturity: initial
sort: 4
---

# Routing

Routing dispatch the commands of the CLI application into user provided handler function. The handler function ared defined by the `route` configuration property of the application or of a command.

On execution, arguments are transparently parsed and the handler function associated to the application or a command is called by the context object as first argument. It contains the following properties:

* `argv`   
   CLI arguments
* `params`   
   Extracted parameters from `argv`
