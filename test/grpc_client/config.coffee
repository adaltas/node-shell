
parameters = require '../../src'
client = require '../../src/plugins/grpc_client/client'

describe 'grpc_client.config', ->
  
  it 'get application configuration', ->
    app = parameters
      grpc:
        address: '0.0.0.0'
        port: 50051
    await app.grpc_start()
    conn = client address: '127.0.0.1', port: 50051
    response = await conn.config []
    try
      response.config.name.should.eql 'myapp'
    finally
      await app.grpc_stop()
    null
