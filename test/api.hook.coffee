
{ Writable } = require 'stream'
parameters = require '../src'

describe 'api.hook', ->
  
  it 'validation', ->
    (->
      parameters().hook 'hook_sth'
    ).should.throw 'Invalid Hook Argument: function hook expect 3 or 4 arguments name, args, hooks? and handler, got 1 arguments'
  
  it 'return value from handler', ->
    app = parameters()
    app.hook 'hook_sth', {}
    , ({}) ->
      'value is here'
    .should.equal 'value is here'
      
  it 'pass user context', ->
    app = parameters()
    app.hook 'hook_sth',
      pass: 'sth'
    , ({pass}) ->
      pass.should.eql 'sth'
        
  it.only 'provide user register', ->
    app = parameters()
    app.hook 'hook_sth',
      pass: 'sth'
    , (context, handler) ->
      console.log 'ok'
      context.pass = 'sth else'
      handler
    , ({pass}) ->
      pass.should.eql 'sth else'
    
    
