
parameters = require 'parameters'
require '../src'

describe 'grpc_server.config', ->
  
  it 'default', ->
    app = parameters
      grpc: {}
    app.confx().get().grpc
    .should.eql
      'address': '127.0.0.1'
      'command_protobuf': false
      'port': 61234
