
import {shell} from 'shell'
import grpc_server from '../lib/index.js'

describe 'grpc_server.stop', ->
  
  it 'return false unless started', ->
    app = shell
      plugins: [grpc_server]
      grpc:
        address: '0.0.0.0'
        port: 61234
    status = await app.grpc_stop()
    status.should.be.false()
