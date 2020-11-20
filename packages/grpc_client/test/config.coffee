
parameters = require 'parameters'
require '@parameters/grpc_server'
client = require '../src/client'

describe 'grpc_client.config', ->
  
  it 'get application configuration', ->
    app = parameters
      grpc:
        address: '0.0.0.0'
        port: 61234
    await app.grpc_start()
    conn = client address: '127.0.0.1', port: 61234
    response = await conn.config []
    try
      response.config.name.should.eql 'myapp'
    finally
      await app.grpc_stop()
    null
