
shell = require 'shell/lib'
require '../lib'

describe 'grpc_server.stop', ->
  
  it 'return false unless started', ->
    app = shell
      grpc:
        address: '0.0.0.0'
        port: 61234
    status = await app.grpc_stop()
    status.should.be.false()
