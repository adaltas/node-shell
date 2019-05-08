
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
    
  it 'router_call can modify inject parameters into the route', (next) ->
    parameters
      route: ({writer}) ->
        writer.write 'gotit'
        writer.end()
    .register
      router_call: ({}, handler) ->
        arguments[0].writer = writer (data) ->
          data.should.eql 'gotit'
          next()
        handler
    .route []
