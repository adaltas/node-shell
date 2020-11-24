
    # Dependencies
    proto = require '@parametersjs/grpc_proto'
    try
      grpc = require 'grpc'
    catch
      grpc = require '@grpc/grpc-js'
    
    module.exports = (config={}) ->
      config.address ?= '127.0.0.1'
      config.port ?= 50051
      # Load the definition
      packageDefinition = proto.loadSync()
      shell_proto = grpc.loadPackageDefinition(packageDefinition).shell
      # Instantiate the client
      endpoint = "#{config.address}:#{config.port}"
      client = new shell_proto.Shell endpoint, grpc.credentials.createInsecure()
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
