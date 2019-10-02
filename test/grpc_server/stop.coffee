
parameters = require '../../src'

describe 'grpc_server.stop', ->
  
  it 'return false unless started', ->
    app = parameters
      grpc:
        address: '0.0.0.0'
        port: 61234
    status = await app.grpc_stop()
    status.should.be.false()
