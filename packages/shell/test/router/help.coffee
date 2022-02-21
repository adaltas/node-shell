
import { Writable } from 'stream'
import {shell} from '../../lib/index.js'

writer = (callback) ->
  chunks = []
  new Writable
    write: (chunk, encoding, callback) ->
      chunks.push chunk.toString()
      callback()
  .on 'finish', ->
    callback chunks.join ''

describe 'router.help', ->

  it 'Unhandled leftover', ->
    output = await new Promise (resolve, reject) ->
      shell
        router:
          stderr: writer (output) ->
            resolve output
          stderr_end: true
      .route ['invalid', 'leftover']
    output.should.match /^\s+Invalid Argument: fail to interpret all arguments "invalid leftover"/
    output.should.match /^\s+myapp - No description yet/m
      
  it 'Undeclared options in stric mode', ->
    output = await new Promise (resolve, reject) ->
      shell
        router:
          stderr: writer (output) ->
            resolve output
          stderr_end: true
        strict: true
      .route ['--opt', 'val']
    output.should.match /^\s+Invalid Argument: the argument --opt is not a valid option/
    output.should.match /^\s+myapp - No description yet/m
      
  it 'Undeclared options inside a command in stric mode', ->
    output = await new Promise (resolve, reject) ->
      shell
        commands:
          'server': {}
        router:
          stderr: writer (output) ->
            resolve output
          stderr_end: true
        strict: true
      .route ['server', '--opt', 'val']
    output.should.match /^\s+Invalid Argument: the argument --opt is not a valid option/
    output.should.match /^\s+myapp server - No description yet for the server command/m
