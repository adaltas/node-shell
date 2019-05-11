
parameters = require '../../src'

describe 'grpc.start', ->
  
  it 'get application configuration', ->
    app = parameters
      grpc:
        address: '0.0.0.0'
        port: 50051
    await app.grpc_start()
    (->
      app.grpc_start()
    ).should.throw 'GRPC Server Already Started'
    await app.grpc_stop()
