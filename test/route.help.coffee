
fs = require 'fs'
os = require 'os'
{ Writable } = require 'stream'
parameters = require '../src'

writer = (callback) ->
  chunks = []
  new Writable
    write: (chunk, encoding, callback) ->
      chunks.push chunk.toString()
      callback()
  .on 'finish', ->
    callback chunks.join ''

describe 'route.error', ->

  it 'Unhandled leftover', (next) ->
    parameters
      help:
        writer: writer (output) ->
          output.should.match /^\s+Fail to parse end of command "invalid,leftover"/
          output.should.match /^\s+myapp - No description yet/m
          next()
        end: true
    .route ['invalid', 'leftover']
      
  it 'Undeclared options in stric mode', (next) ->
    parameters
      help:
        writer: writer (output) ->
          output.should.match /^\s+Invalid option "opt"/
          output.should.match /^\s+myapp - No description yet/m
          next()
        end: true
      strict: true
    .route ['--opt', 'val']
      
  it 'Undeclared options inside a command in stric mode', (next) ->
    parameters
      commands:
        'server': {}
      help:
        writer: writer (output) ->
          output.should.match /^\s+Invalid option "opt"/
          output.should.match /^\s+myapp server - No description yet for the server command/m
          next()
        end: true
      strict: true
    .route ['server', '--opt', 'val']
