
import {Writable} from 'node:stream'
import {is_object_literal} from 'mixme'
import {shell} from 'shell'
import grpc_server from '../lib/index.js'

writer = (callback) ->
  chunks = []
  new Writable
    write: (chunk, encoding, callback) ->
      chunks.push chunk.toString()
      callback()
  .on 'finish', ->
    callback chunks.join ''

describe 'grpc.command.protobuf', ->
  
  it 'format json', ->
    app = shell
      plugins: [grpc_server]
      router:
        stdout: writer (output) ->
          proto = JSON.parse output
          is_object_literal(proto).should.be.true()
      grpc:
        command_protobuf: true
    app.route ['shell', 'protobuf', '--format', 'json']
  
  it 'format proto', ->
    app = shell
      plugins: [grpc_server]
      router:
        stdout: writer (output) ->
          output.should.match /^package shell;$/m
      grpc:
        command_protobuf: true
    app.route ['shell', 'protobuf', '--format', 'proto']
