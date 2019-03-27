
parameters = require '../src'
  
describe 'options shortcut', ->

  it 'throw error for an undefined shortcut', ->
    # Test a boolean (no value) argument
    params = parameters()
    (->
      params.parse ['-c']
    ).should.throw 'Invalid Shortcut: "-c"'
    (->
      params.parse ['-c', 'a value']
    ).should.throw 'Invalid Shortcut: "-c"'

  it 'handle help shortcut', ->
    # Test a boolean (no value) argument
    parameters()
    .parse ['-h']
    .help.should.be.True()
