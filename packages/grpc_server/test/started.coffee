
import {shell} from 'shell'
import grpc_server from '../lib/index.js'

describe 'grpc_server.started', ->
  
  it 'get application configuration', ->
    app = shell
      plugins: [grpc_server]
      grpc:
        address: '0.0.0.0'
        port: 61234
    await app.grpc_start()
    app.grpc_started().should.be.true()
    await app.grpc_stop()
    app.grpc_started().should.be.false()
