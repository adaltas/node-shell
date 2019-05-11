
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
          config.router.writer ?= 'stderr'
          config.router.end ?= false
          config.router.route ?= path.resolve __dirname, '../routes/help'
          if typeof config.router.writer is 'string'
            throw error [
              'Invalid Help Configuration:'
              'accepted values are ["stdout", "stderr"] when writer is a string,'
              "got #{JSON.stringify config.router.writer}"
            ] unless config.router.writer in ['stdout', 'stderr']
          else unless config.router.writer instanceof stream.Writable
            throw error [
              "Invalid Help Configuration:"
              "writer must be a string or an instance of stream.Writer,"
              "got #{JSON.stringify config.router.writer}"
            ] unless config.router.writer in ['stdout', 'stderr']
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
    
## `route(argv)` or `route(params)` or `route(process)`

* `cli_arguments`: `[string] | process` The arguments to parse into parameters, accept the [Node.js process](https://nodejs.org/api/process.html) instance or an [argument list](https://nodejs.org/api/process.html#process_process_argv) provided as an array of strings, optional, default to `process`.
* `...users_arguments`: `any` Any arguments that will be passed to the executed function associated with a route.
* Returns: `any` Whatever the route function returns.

How to use the `route` method to execute code associated with a particular command.

    Parameters::route = (argv = process, args...) ->
      # Normalize arguments
      # Remove node and script argv elements
      if argv is process
        argv = argv.argv.slice 2
      else unless Array.isArray argv
        throw error [
          'Invalid Router Arguments:'
          'first argument must be an argv array or the process object,'
          "got #{JSON.stringify process}"
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
        if config.router.writer is 'stdout'
          writer = process.stdout
        else if config.router.writer is 'stderr'
          writer = process.stderr
        else if config.router.writer instanceof stream.Writable
          writer = config.router.writer
        @hook 'router_call',
          argv: argv
          command: command
          error: err
          params: params
          args: args
          writer: writer
        , (context) =>
          route.call @, context, ...args
      route_error = (err, command) =>
        argv = if command.length
        then ['help', ...command]
        else ['--help']
        params = @parse argv
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
          argv = if command.length
          then ['help', ...command]
          else ['--help']
          params = @parse argv
          route = route_load @config.router.route
        else
          route = route_load route
        route_call route, command, params, err, args
      # Read parameters
      try params = @parse argv
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
