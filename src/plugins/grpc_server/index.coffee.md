
## Plugin "grpc"

    # Dependencies
    path = require 'path'
    # pad = require 'pad'
    error = require '../../utils/error'
    {mutate} = require 'mixme'
    # grpc = require '@grpc/grpc-js'
    grpc = require 'grpc'
    protoLoader = require '@grpc/proto-loader'
    # Parameters & plugins
    Parameters = require '../../Parameters'
    require '../../plugins/config'
    require '../../plugins/router'
    { Transform } = require 'stream'

    Parameters::init = ( (parent) ->
      ->
        # Plugin configuration
        @register configure_set: ({config, command}, handler) ->
          return handler if command.length
          config.grpc ?= {}
          config.grpc.address ?= '0.0.0.0'
          config.grpc.port ?= 50051
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
                  format: one_of: ['json', 'proto'], default: 'proto'
                route: path.resolve __dirname, './route_shell_protobuf'
          handler
        parent.call @, arguments...
        # Register the "shell protobuf" command
        @register router_call: (context, handler) ->
          return handler unless @grpc_started()
          [call] = context.args
          if call.is_grpc
            if call.readable
              context.reader = call
            if call.writable
              context.writer = call
              context.writer.write = ((write) ->
                (chunk, ...args) ->
                  chunk = data: chunk
                  write.call @, chunk, ...args
              )(context.writer.write)
          handler
    )(Parameters::init)
    
    get_handlers = (definition) ->
      ping: (call, callback) ->
        callback null,
          message: call.request.name
      config: (call, callback) ->
        config = @confx(call.request.command).get()
        callback null, config: config
      run: (call) ->
        call.is_grpc = true
        @route call.request.argv, call

    Parameters::grpc_start = (callback) ->
      if @_server?.started
        throw error 'GRPC Server Already Started'
      appconfig = @confx().get()
      # Load the definition
      proto_path = path.resolve __dirname, './shell.proto'
      packageDefinition = protoLoader.loadSync proto_path,
        keepCase: true
        longs: String
        enums: String
        defaults: true
        oneofs: true
      shell_definition = grpc.loadPackageDefinition(packageDefinition).shell
      # Instantiate the server
      server = new grpc.Server()
      handlers = get_handlers shell_definition
      handlers[name] = handler.bind @ for name, handler of handlers
      server.addService shell_definition.Shell.service, handlers
      endpoint = "#{appconfig.grpc.address}:#{appconfig.grpc.port}"
      promise = new Promise (resolve, reject) ->
        server.bindAsync endpoint, grpc.ServerCredentials.createInsecure(), (err, port) ->
          if err
          then reject err
          else resolve port
      server.start()
      @_server = server
      promise

    Parameters::grpc_stop = ->
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

    Parameters::grpc_started = ->
      !!@_server?.started
