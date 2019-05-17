
    # Dependencies
    path = require 'path'
    # grpc = require '@grpc/grpc-js'
    grpc = require 'grpc'
    protoLoader = require '@grpc/proto-loader'
    
    module.exports = (config={}) ->
      config.address ?= '127.0.0.1'
      config.port ?= 50051
      
      # Load the definition
      proto_path = path.resolve __dirname, '../grpc_server/shell.proto'
      packageDefinition = protoLoader.loadSync proto_path,
        keepCase: true
        longs: String
        enums: String
        defaults: true
        oneofs: true
      shell_proto = grpc.loadPackageDefinition(packageDefinition).shell
      # Instantiate the client
      endpoint = "#{config.address}:#{config.port}"
      console.log 'endpoint', endpoint
      client = new shell_proto.Shell(endpoint, grpc.credentials.createInsecure())
      for k, service of shell_proto.Shell.service
        # Response stream return a readable stream
        # Otherwise, convert the callback approach to a promise
        unless service.responseStream is true
          client[k] = ( (handler) -> ->
            self = @
            args = arguments
            new Promise (resolve, reject) ->
              handler.call self, args..., (err, response) ->
                if err
                then reject err
                else resolve response
          )(client[k])
      client
