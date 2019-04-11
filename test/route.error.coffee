
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

describe 'route.help', ->
  
  describe 'option', ->

    it 'application help', (next) ->
      parameters
        help:
          writer: writer (output) ->
            output.should.match /myapp - No description yet/
            next()
          end: true
      .route ['--help']

    it 'command help', (next) ->
      parameters
        help:
          writer: writer (output) ->
            output.should.match /myapp server - No description yet for the server command/
            next()
          end: true
        commands:
          'server':
            commands:
              'start': {}
      .route ['server', '--help']
        
  describe 'help command', ->

    it 'application help', (next) ->
      parameters
        help:
          writer: writer (output) ->
            output.should.match /^\s+Missing "route" definition for application/
            output.should.match /^\s+myapp - No description yet/m
            next()
          end: true
      .route []

    it 'command help', (next) ->
      parameters
        help:
          writer: writer (output) ->
            output.should.match /myapp server - No description yet for the server command/
            next()
          end: true
        commands:
          'server':
            commands:
              'start': {}
      .route ['help', 'server']
        
  describe 'command', ->
    
    it 'command without route and with orphan print help', (next) ->
      parameters
        help:
          writer: writer (output) ->
            output.should.not.match /^\s+Missing "route" definition/
            output.should.match /^\s+myapp server start - No description yet for the start command/m
            next()
          end: true
        commands:
          'server':
            commands:
              'start':
                commands:
                  'sth': {}
      .route ['server', 'start']
    
    it 'print error message if leaf', (next) ->
      parameters
        help:
          writer: writer (output) ->
            output.should.match /^\s+Missing "route" definition for command \["server","start"\]/
            output.should.match /^\s+myapp server start - No description yet for the start command/m
            next()
          end: true
        commands:
          'server':
            commands:
              'start': {}
      .route ['server', 'start']
        
  describe 'error', ->
    
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
