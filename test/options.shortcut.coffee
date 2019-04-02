
parameters = require '../src'
  
describe 'options.shortcut', ->

  it 'throw error for an undefined shortcut', ->
    # Test a boolean (no value) argument
    app = parameters()
    (->
      app.parse ['-c']
    ).should.throw 'Invalid Shortcut: "-c"'
    (->
      app.parse ['-c', 'a value']
    ).should.throw 'Invalid Shortcut: "-c"'

  it 'handle help shortcut', ->
    # Test a boolean (no value) argument
    parameters()
    .parse ['-h']
    .help.should.be.True()
