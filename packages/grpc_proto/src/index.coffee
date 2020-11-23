
protoLoader = require '@grpc/proto-loader'

module.exports =
  resolve: ->
    require.resolve './shell.proto'
  load: (proto) ->
    proto ?= module.exports.resolve()
    protoLoader.load proto,
      keepCase: true
      longs: String
      enums: String
      defaults: true
      oneofs: true
  loadSync: (proto) ->
    proto ?= module.exports.resolve()
    protoLoader.loadSync proto,
      keepCase: true
      longs: String
      enums: String
      defaults: true
      oneofs: true
