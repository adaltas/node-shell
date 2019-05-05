
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
  
describe 'api.register', ->
  
  it 'return current instance', ->
    app = parameters()
    app.register
      hook_sth: ({}, handler) -> handler
    .should.equal app
