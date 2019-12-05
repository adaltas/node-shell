
# Parameters

Usage: `parameters(config)`

    Parameters = require './Parameters'
    require './plugins/router'
    require './plugins/config'
    require './plugins/args'
    require './plugins/help'
    require './plugins/grpc_server'

    module.exports = (config) ->
      new Parameters config
