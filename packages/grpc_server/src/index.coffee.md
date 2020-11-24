
## Plugin "grpc"

    # Dependencies
    path = require 'path'
    utils = require 'shell/lib/utils'
    {mutate} = require 'mixme'
    try
      grpc = require 'grpc'
    catch
      grpc = require '@grpc/grpc-js'
    proto = require '@shell-js/grpc_proto'
    # Shell & plugins
    Shell = require 'shell/lib/Shell'
    require 'shell/lib/plugins/config'
    require 'shell/lib/plugins/router'
    { Transform } = require 'stream'

    Shell::init = ( (parent) ->
      ->
        # Plugin configuration
        @register configure_set: ({config, command}, handler) ->
          return handler if command.length
          config.grpc ?= {}
          config.grpc.address ?= '127.0.0.1'
          config.grpc.port ?= 61234
          config.grpc.command_protobuf ?= false
          handler
        # Register the "shell protobuf" command
        @register configure_set: ({config, command}, handler) ->
          return handler if command.length
          return handler unless config.grpc.command_protobuf
          mutate config,
            commands:
              'shell': commands: 'protobuf':
                options:
                  format: enum: ['json', 'proto'], default: 'proto'
                handler: path.resolve __dirname, './route_shell_protobuf'
          handler
        parent.call @, arguments...
    )(Shell::init)

    passthrough = ->
      new Transform
        objectMode: true
        transform: (chunk, encoding, callback) ->
          chunk = data: chunk
          callback null, chunk
    
    get_handlers = (definition) ->
      ping: (call, callback) ->
        callback null,
          message: call.request.name
      config: (call, callback) ->
        config = @confx(call.request.command).get()
        callback null, config: config
      run: (call) ->
        context =
          argv: call.request.argv
          is_grpc: true
        if call.readable
          context.reader = call
        if call.writable
          context.stdout = passthrough()
          context.stdout.pipe call
          context.stderr = passthrough()
          context.stderr.pipe call
        @route context

    Shell::grpc_start = (callback) ->
      if @_server?.started
        throw utils.error 'GRPC Server Already Started'
      appconfig = @confx().get()
      # Load the definition
      packageDefinition = proto.loadSync()
      shell_definition = grpc.loadPackageDefinition(packageDefinition).shell
      # Instantiate the server
      server = new grpc.Server()
      handlers = get_handlers shell_definition
      handlers[name] = handler.bind @ for name, handler of handlers
      server.addService shell_definition.Shell.service, handlers
      endpoint = "#{appconfig.grpc.address}:#{appconfig.grpc.port}"
      promise = new Promise (resolve, reject) ->
        server.bindAsync endpoint, grpc.ServerCredentials.createInsecure(), (err, port) ->
          server.start()
          if err
          then reject err
          else resolve port
      @_server = server
      promise

    Shell::grpc_stop = ->
      # server = @_server
      new Promise (resolve, reject) =>
        return resolve false unless @grpc_started()
        @_server.tryShutdown (err) =>
          # Note, as of june 2019,
          # grpc marks the server as started but not as stopped
          @_server.started = false
          if err
          then reject err
          else resolve true

    Shell::grpc_started = ->
      !!@_server?.started
