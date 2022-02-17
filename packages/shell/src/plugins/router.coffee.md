
## Plugin "router"

    # Dependencies
    path = require 'path'
    stream = require 'stream'
    utils = require '../utils'
    {clone, merge, is_object_literal} = require 'mixme'
    # Shell.js & plugins
    Shell = require '../Shell'
    require '../plugins/config'

    Shell::init = ( (parent) ->
      ->
        @register configure_set: ({config, command}, handler) ->
          return handler if command.length
          config.router ?= {}
          config.router.handler ?= path.resolve __dirname, '../routes/help'
          config.router.promise ?= false
          config.router.stdin ?= process.stdin
          config.router.stdout ?= process.stdout
          config.router.stdout_end ?= false
          config.router.stderr ?= process.stderr
          config.router.stderr_end ?= false
          unless config.router.stdin instanceof stream.Readable
            throw utils.error [
              "Invalid Configuration Property:"
              "router.stdin must be an instance of stream.Readable,"
              "got #{JSON.stringify config.router.stdin}"
            ]
          unless config.router.stdout instanceof stream.Writable
            throw utils.error [
              "Invalid Configuration Property:"
              "router.stdout must be an instance of stream.Writable,"
              "got #{JSON.stringify config.router.stdout}"
            ]
          unless config.router.stderr instanceof stream.Writable
            throw utils.error [
              "Invalid Configuration Property:"
              "router.stderr must be an instance of stream.Writable,"
              "got #{JSON.stringify config.router.stderr}"
            ]
          handler
        parent.call @, arguments...
    )(Shell::init)
    
    Shell::init = ( (parent) ->
      ->
        @register configure_set: ({config, command}, handler) ->
          return handler unless config.handler
          throw utils.error [
            'Invalid Route Configuration:'
            "accept string or function"
            "in application," unless command.length
            "in command #{JSON.stringify command.join ' '}," if command.length
            "got #{JSON.stringify config.handler}"
          ] unless typeof config.handler in ['function', 'string']
          handler
        parent.call @, arguments...
    )(Shell::init)
    
## Method `route(context, ...users_arguments)`

* `cli_arguments`: `[string] | object | process` The arguments to parse into arguments, accept the [Node.js process](https://nodejs.org/api/process.html) instance, an [argument list](https://nodejs.org/api/process.html#process_process_argv) provided as an array of strings or the context object; optional, default to `process`.
* `...users_arguments`: `any` Any arguments that will be passed to the executed function associated with a route.
* Returns: `Promise<any>` Whatever the route function returns wrapped inside a promise.

How to use the `route` method to execute code associated with a particular command.

    Shell::route = (context = {}, args...) ->
      # Normalize arguments
      if Array.isArray context
        context = argv: context
      else unless is_object_literal context
        throw utils.error [
          'Invalid Router Arguments:'
          'first argument must be a context object or the argv array,'
          "got #{JSON.stringify context}"
        ]
      appconfig = @confx().get()
      route_load = (handler) =>
        if typeof handler is 'string'
          @load handler
        else if typeof handler is 'function'
          handler
        else
          throw utils.error "Invalid Handler: expect a string or a function, got #{handler}"
      route_call = (handler, command, params, err, args) =>
        config = @confx().get()
        context = {
          argv: process.argv.slice 2
          command: command
          error: err
          params: params
          args: args
          stdin: config.router.stdin
          stdout: config.router.stdout
          stdout_end: config.router.stdout_end
          stderr: config.router.stderr
          stderr_end: config.router.stderr_end
        , ...context}
        @hook 'router_call', context, (context) =>
          unless config.router.promise
            return handler.call @, context, ...args
          # Otherwise wrap result in a promise 
          try
            result = handler.call @, context, ...args
            retun result if result?.then
            new Promise (resolve, reject) ->
              resolve result
          catch err
            new Promise (resolve, reject) ->
              reject err
      route_error = (err, command) =>
        context.argv = if command.length
        then ['help', ...command]
        else ['--help']
        params = @parse context.argv
        handler = route_load @config.router.handler
        route_call handler, command, params, err, args
      route_from_config = (config, command, params) =>
        handler = config.handler
        unless handler
          # Provide an error message if leaf command without a handler
          unless Object.keys(config.commands).length  # Object.keys(config.commands).length or
            err = if config.root
            then utils.error [
              'Missing Application Handler:'
              'a \"handler\" definition is required when no child command is defined'
            ]
            else utils.error [
              'Missing Command Handler:'
              "a \"handler\" definition #{JSON.stringify params[appconfig.command]} is required when no child command is defined"
            ]
          # Convert argument to an help command
          context.argv = if command.length
          then ['help', ...command]
          else ['--help']
          params = @parse context.argv
          handler = route_load @config.router.handler
        else
          handler = route_load handler
        route_call handler, command, params, err, args
      # Read arguments
      try params = @parse context.argv
      catch err then return route_error err, err.command or []
      # Print help
      if command = @helping params
        # this seems wrong, must be the handler of the command
        handler = @load appconfig.router.handler
        return route_call handler, command, params, err, args
      # Load a command route
      else
        # Return undefined if not parsing command based arguments
        command = params[appconfig.command]
        # TODO: not tested yet, construct a commands array like in flatten mode when extended is activated
        command = (for i in [0...params.length] then params[i][appconfig.command]) if appconfig.extended
        config = @confx(command).get()
        route_from_config config, command or [], params
