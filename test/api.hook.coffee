
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
  
describe 'api.hook', ->
  
  it 'return value from handler', ->
    app = parameters()
    app.hook 'hook_sth', {}
    , ({}) ->
      'value is here'
    .should.equal 'value is here'
    
    
