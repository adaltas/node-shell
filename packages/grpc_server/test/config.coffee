
import {shell} from 'shell'
import grpc_server from '../lib/index.js'

describe 'grpc_server.config', ->
  
  it 'default', ->
    app = shell
      plugins: [grpc_server]
      grpc: {}
    app.confx().get().grpc
    .should.eql
      'address': '127.0.0.1'
      'command_protobuf': false
      'port': 61234
