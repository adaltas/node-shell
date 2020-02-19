
## Plugin "router"

    # Dependencies
    path = require 'path'
    stream = require 'stream'
    error = require '../utils/error'
    {clone, merge, is_object_literal} = require 'mixme'
    # Parameters & plugins
    Parameters = require '../Parameters'
    require '../plugins/config'

    Parameters::init = ( (parent) ->
      ->
        @register configure_set: ({config, command}, handler) ->
          return handler if command.length
          config.router ?= {}
          config.router.route ?= path.resolve __dirname, '../routes/help'
          config.router.stdout ?= process.stdout
          config.router.stdout_end ?= false
          config.router.stderr ?= process.stderr
          config.router.stderr_end ?= false
          unless config.router.stdout instanceof stream.Writable
            throw error [
              "Invalid Configuration Property:"
              "router.stdout must be an instance of stream.Writer,"
              "got #{JSON.stringify config.router.stdout}"
            ]
          unless config.router.stderr instanceof stream.Writable
            throw error [
              "Invalid Configuration Property:"
              "router.stderr must be an instance of stream.Writer,"
              "got #{JSON.stringify config.router.stderr}"
            ]
          handler
        parent.call @, arguments...
    )(Parameters::init)
    
    Parameters::init = ( (parent) ->
      ->
        @register configure_set: ({config, command}, handler) ->
          return handler unless config.route
          throw error [
            'Invalid Route Configuration:'
            "accept string or function"
            "in application," unless command.length
            "in command #{JSON.stringify command.join ' '}," if command.length
            "got #{JSON.stringify config.route}"
          ] unless typeof config.route in ['function', 'string']
          handler
        parent.call @, arguments...
    )(Parameters::init)
    
## Method `route(context, ...users_arguments)`

* `cli_arguments`: `[string] | object | process` The arguments to parse into parameters, accept the [Node.js process](https://nodejs.org/api/process.html) instance, an [argument list](https://nodejs.org/api/process.html#process_process_argv) provided as an array of strings or the context object; optional, default to `process`.
* `...users_arguments`: `any` Any arguments that will be passed to the executed function associated with a route.
* Returns: `any` Whatever the route function returns.

How to use the `route` method to execute code associated with a particular command.

    Parameters::route = (context = {}, args...) ->
      # Normalize arguments
      if Array.isArray context
        context = argv: context
      else unless is_object_literal context
        throw error [
          'Invalid Router Arguments:'
          'first argument must be a context object or the argv array,'
          "got #{JSON.stringify context}"
        ]
      appconfig = @confx().get()
      route_load = (route) =>
        if typeof route is 'string'
          @load route
        else if typeof route is 'function'
          route
        else
          throw Error "Invalid Route: expect a string or a function, got #{route}"
      route_call = (route, command, params, err, args) =>
        config = @confx().get()
        context = {
          argv: process.argv.slice 2
          command: command
          error: err
          params: params
          args: args
          stdout: config.router.stdout
          stdout_end: config.router.stdout_end
          stderr: config.router.stderr
          stderr_end: config.router.stderr_end
        , context...}
        @hook 'router_call', context, (context) =>
          route.call @, context, ...args
      route_error = (err, command) =>
        context.argv = if command.length
        then ['help', ...command]
        else ['--help']
        params = @parse context.argv
        route = route_load @config.router.route
        route_call route, command, params, err, args
      route_from_config = (config, command, params) =>
        route = config.route
        unless route
          # Provide an error message if leaf command without a route
          unless Object.keys(config.commands).length  # Object.keys(config.commands).length or
            err = if config.root
            then error [
              'Missing Application Route:'
              'a \"route\" definition is required when no child command is defined'
            ]
            else error [
              'Missing Command Route:'
              "a \"route\" definition #{JSON.stringify params[appconfig.command]} is required when no child command is defined"
            ]
          # Convert argument to an help command
          context.argv = if command.length
          then ['help', ...command]
          else ['--help']
          params = @parse context.argv
          route = route_load @config.router.route
        else
          route = route_load route
        route_call route, command, params, err, args
      # Read parameters
      try params = @parse context.argv
      catch err then return route_error err, err.command or []
      # Print help
      if command = @helping params
        route = @load appconfig.router.route
        return route_call route, command, params, err, args
      # Load a command route
      else
        # Return undefined if not parsing command based arguments
        command = params[appconfig.command]
        # TODO: not tested yet, construct a commands array like in flatten mode when extended is activated
        command = (for i in [0...params.length] then params[i][appconfig.command]) if appconfig.extended
        config = @confx(command).get()
        route_from_config config, command or [], params
