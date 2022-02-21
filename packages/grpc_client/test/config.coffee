
import {shell} from 'shell'
import '@shell-js/grpc_server'
import client from '../lib/client.js'

describe 'grpc_client.config', ->
  
  it 'get application configuration', ->
    app = shell
      grpc:
        address: '0.0.0.0'
        port: 61234
    await app.grpc_start()
    conn = client address: '127.0.0.1', port: 61234
    response = await conn.config command: []
    try
      response.config.name.should.eql 'myapp'
    finally
      await app.grpc_stop()
    null
