
parameters = require '../../src'
{ Writable } = require 'stream'
{ is_object_literal } = require 'mixme'

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
    app = parameters
      router:
        stdout: writer (output) ->
          proto = JSON.parse output
          is_object_literal(proto).should.be.true()
      grpc:
        command_protobuf: true
    app.route ['shell', 'protobuf', '--format', 'json']
  
  it 'format proto', ->
    app = parameters
      router:
        writer: writer (output) ->
          output.should.match /^package shell;$/m
      grpc:
        command_protobuf: true
    app.route ['shell', 'protobuf', '--format', 'proto']
