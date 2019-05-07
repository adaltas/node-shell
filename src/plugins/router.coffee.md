
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
        index = 2
        argv = argv.argv
      else unless Array.isArray argv
        throw error [
          'Invalid Router Arguments:'
          'first argument must be an argv array or the process object,'
          "got #{JSON.stringify process}"
        ]
      route_call = (route, commands, params, err, args) =>
        @hook 'router_call',
          argv: argv
          command: commands
          error: err
          params: params
          args: args
        , (context) =>
          route.call @, context, ...args
      route_error = (err, commands) =>
        argv = if commands.length
        then ['help', ...commands]
        else ['--help']
        params = @parse argv
        route = @load @config.router.route
        route_call route, commands, params, err, args
      route_from_config = (config, commands, params) =>
        route = config.route
        unless route
          # Provide an error message if leaf command does not define any route
          unless Object.keys(config.commands).length or route
            err = if config.root
            then error [
              'Missing Application Route:'
              'a \"route\" definition is required when no commands are defined'
            ]
            else error [
              'Missing Command Route:'
              "a \"route\" definition #{JSON.stringify params[@config.command]} is required when no child commands are defined"
            ]
          # Convert argument to an help command
          argv = if commands.length
          then ['help', ...commands]
          else ['--help']
          params = @parse argv
          route = @load @config.router.route
        else
          route = @load route if typeof route is 'string'
        route_call route, commands, params, err, args
      # Read parameters
      try params = @parse argv
      catch err then return route_error err, err.command or []
      # Print help
      if commands = @helping params
        route = @load @config.router.route
        return route_call route, commands, params, err, args
      # Load a command route
      else if commands = params[@config.command]
        # TODO: not tested yet, construct a commands array like in flatten mode when extended is activated
        commands = (for i in [0...params.length] then params[i][@config.command]) if @config.extended
        config = (configure = (config, commands) ->
          config = config.commands[commands.shift()]
          if commands.length
          then configure config, commands
          else config
        )(@config, clone commands)
        route_from_config config, commands, params
      # Load an application route
      else
        route_from_config @config, [], params
