
parameters = require 'parameters'
require '@parametersjs/grpc_server'
client = require '../src/client'

describe 'grpc_client.run', ->
  
  it 'get application configuration', ->
    app = parameters
      grpc:
        address: '0.0.0.0'
        port: 61234
      commands: 'ping': commands: 'pong':
        options: 'message': {}
        handler: ({stdout}) ->
          stdout.write 'hello'
          stdout.end()
    await app.grpc_start()
    conn = client address: '127.0.0.1', port: 61234
    call = conn.run argv: ['ping', 'pong', '--message', 'hello']
    new Promise (resolve, reject) ->
      result = []
      call.on 'data', ({data}) ->
        result.push data
      call.on 'error', (err) ->
        reject err
      call.on 'end', ->
        try result.join('').should.eql 'hello'
        catch err then reject err
        resolve()
      call.on 'status', (status) ->
        status.code.should.eql 0
        app.grpc_stop()
