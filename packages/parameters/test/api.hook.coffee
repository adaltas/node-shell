
shell = require '../src'

describe 'api.hook', ->
  
  it 'validation', ->
    (->
      shell().hook 'hook_sth'
    ).should.throw 'Invalid Hook Argument: function hook expect 3 or 4 arguments name, args, hooks? and handler, got 1 arguments'
  
  it 'return value from handler', ->
    app = shell()
    app.hook 'hook_sth', {}, ->
      'value is here'
    .should.equal 'value is here'
      
  it 'pass user context', ->
    app = shell()
    app.hook 'hook_sth',
      pass: 'sth'
    , ({pass}) ->
      pass.should.eql 'sth'
        
  it 'provide user register', ->
    app = shell()
    app.hook 'hook_sth',
      pass: 'sth'
    , (context, handler) ->
      context.pass = 'sth else'
      handler
    , ({pass}) ->
      pass.should.eql 'sth else'
    
    
