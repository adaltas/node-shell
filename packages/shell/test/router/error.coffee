
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

describe 'router.error', ->
  
  describe 'option', ->

    it 'application help', ->
      output = await new Promise (resolve, reject) ->
        shell
          router:
            stderr: writer resolve
            stderr_end: true
        .route ['--help']
        .catch reject
      output.should.match /myapp - No description yet/

    it 'command help', ->
      output = await new Promise (resolve, reject) ->
        shell
          router:
            stderr: writer resolve
            stderr_end: true
          commands:
            'server':
              commands:
                'start': {}
        .route ['server', '--help']
        .catch reject
      output.should.match /myapp server - No description yet for the server command/
        
  describe 'help command', ->

    it 'application help', ->
      output = await new Promise (resolve, reject) ->
        shell
          router:
            stderr: writer resolve
            stderr_end: true
        .route []
        .catch reject
      output.should.match /^\s+Missing Application Handler: a "handler" definition is required when no child command is defined/
      output.should.match /^\s+myapp - No description yet/m

    it 'command help', ->
      output = await new Promise (resolve, reject) ->
        shell
          router:
            stderr: writer resolve
            stderr_end: true
          commands:
            'server':
              commands:
                'start': {}
        .route ['help', 'server']
        .catch reject
      output.should.match /myapp server - No description yet for the server command/
        
  describe 'command', ->
    
    it 'command without route and with orphan print help', ->
      output = await new Promise (resolve, reject) ->
        shell
          router:
            stderr: writer resolve
            stderr_end: true
          commands:
            'server':
              commands:
                'start':
                  commands:
                    'sth': {}
        .route ['server', 'start']
        .catch reject
      output.should.not.match /^\s+Missing Command Handler: a "handler" definition \["server","start"\] is required when no child command is defined/
      output.should.match /^\s+myapp server start - No description yet for the start command/m
    
    it 'print error message if leaf', ->
      output = await new Promise (resolve, reject) ->
        shell
          router:
            stderr: writer resolve
            stderr_end: true
          commands:
            'server':
              commands:
                'start': {}
        .route ['server', 'start']
        .catch reject
      output.should.match /^\s+Missing Command Handler: a "handler" definition \["server","start"\] is required when no child command is defined/
      output.should.match /^\s+myapp server start - No description yet for the start command/m
        
  describe 'error', ->
    
    it 'Unhandled leftover', ->
      output = await new Promise (resolve, reject) ->
        shell
          router:
            stderr: writer resolve
            stderr_end: true
        .route ['invalid', 'leftover']
        .catch reject
      output.should.match /^\s+Invalid Argument: fail to interpret all arguments "invalid leftover"/
      output.should.match /^\s+myapp - No description yet/m
        
    it 'Undeclared options in stric mode', ->
      output = await new Promise (resolve, reject) ->
        shell
          router:
            stderr: writer resolve
            stderr_end: true
          strict: true
        .route ['--opt', 'val']
        .catch reject
      output.should.match /^\s+Invalid Argument: the argument --opt is not a valid option/
      output.should.match /^\s+myapp - No description yet/m
        
    it 'Undeclared options inside a command in stric mode', ->
      output = await new Promise (resolve, reject) ->
        shell
          commands:
            'server': {}
          router:
            stderr: writer resolve
            stderr_end: true
          strict: true
        .route ['server', '--opt', 'val']
        .catch reject
      output.should.match /^\s+Invalid Argument: the argument --opt is not a valid option/
      output.should.match /^\s+myapp server - No description yet for the server command/m
