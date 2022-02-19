
shell = require 'shell'
require '../lib'

describe 'grpc_server.start', ->
  
  it 'get application configuration', ->
    app = shell
      grpc:
        address: '0.0.0.0'
        port: 61234
    await app.grpc_start()
    (->
      app.grpc_start()
    ).should.throw 'GRPC Server Already Started'
    await app.grpc_stop()
