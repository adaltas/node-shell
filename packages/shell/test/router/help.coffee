
{ Writable } = require 'stream'
shell = require '../../lib'

writer = (callback) ->
  chunks = []
  new Writable
    write: (chunk, encoding, callback) ->
      chunks.push chunk.toString()
      callback()
  .on 'finish', ->
    callback chunks.join ''

describe 'router.help', ->

  it 'Unhandled leftover', (next) ->
    shell
      router:
        stderr: writer (output) ->
          output.should.match /^\s+Invalid Argument: fail to interpret all arguments "invalid leftover"/
          output.should.match /^\s+myapp - No description yet/m
          next()
        stderr_end: true
    .route ['invalid', 'leftover']
      
  it 'Undeclared options in stric mode', (next) ->
    shell
      router:
        stderr: writer (output) ->
          output.should.match /^\s+Invalid Argument: the argument --opt is not a valid option/
          output.should.match /^\s+myapp - No description yet/m
          next()
        stderr_end: true
      strict: true
    .route ['--opt', 'val']
      
  it 'Undeclared options inside a command in stric mode', (next) ->
    shell
      commands:
        'server': {}
      router:
        stderr: writer (output) ->
          output.should.match /^\s+Invalid Argument: the argument --opt is not a valid option/
          output.should.match /^\s+myapp server - No description yet for the server command/m
          next()
        stderr_end: true
      strict: true
    .route ['server', '--opt', 'val']
