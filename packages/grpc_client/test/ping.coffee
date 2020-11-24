
shell = require 'shell'
require '@shell-js/grpc_server'
client = require '../src/client'

describe 'grpc_client.ping', ->
  
  it 'send and receive a message', ->
    app = shell
      grpc:
        address: '0.0.0.0'
        port: 61234
    await app.grpc_start()
    conn = client address: '127.0.0.1', port: 61234
    response = await conn.ping name: 'pong'
    try
      response.message.should.eql 'pong'
    finally
      await app.grpc_stop()
    null
