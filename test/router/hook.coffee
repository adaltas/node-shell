
{ Writable } = require 'stream'
parameters = require '../../src'

writer = (callback) ->
  chunks = []
  new Writable
    write: (chunk, encoding, callback) ->
      chunks.push chunk.toString()
      callback()
  .on 'finish', ->
    callback chunks.join ''

describe 'router.hook', ->
    
  it 'router_call validate context', ->
    parameters
      route: (->)
    .register
      router_call: (context, handler) ->
        Object.keys(context).sort().should.eql [
          "args", "argv", "command", "error", "params", "stderr", "stderr_end", "stdout", "stdout_end"
        ]
        handler
    .route []
        
  it 'router_call modify parameters', (next) ->
    parameters
      route: ({stdout}) ->
        stdout.write 'gotit'
        stdout.end()
    .register
      router_call: (context, handler) ->
        context.stdout = writer (data) ->
          data.should.eql 'gotit'
          next()
        handler
    .route []
