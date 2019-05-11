
parameters = require '../../src'
client = require '../../src/plugins/grpc_client'

describe 'grpc_server.started', ->
  
  it 'get application configuration', ->
    app = parameters
      grpc:
        address: '0.0.0.0'
        port: 50051
    await app.grpc_start()
    app.grpc_started().should.be.true()
    await app.grpc_stop()
    app.grpc_started().should.be.false()
