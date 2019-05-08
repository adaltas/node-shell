
{ Writable } = require 'stream'
parameters = require '../src'

describe 'api.hook', ->
  
  it 'return value from handler', ->
    app = parameters()
    app.hook 'hook_sth', {}
    , ({}) ->
      'value is here'
    .should.equal 'value is here'
    
    
