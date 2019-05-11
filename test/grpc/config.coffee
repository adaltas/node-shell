
parameters = require '../../src'
client = require '../../src/plugins/grpc_client'

describe 'grpc.config', ->
  
  it 'default', ->
    app = parameters
      grpc: {}
    app.confx().get().grpc
    .should.eql
      'address': '0.0.0.0'
      'command_protobuf': false
      'port': 50051
