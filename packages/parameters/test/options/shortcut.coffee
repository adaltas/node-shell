
parameters = require '../../src'
  
describe 'options.shortcut', ->

  it 'throw error for an undeclared shortcut', ->
    # Test a boolean (no value) argument
    app = parameters()
    (->
      app.parse ['-c']
    ).should.throw 'Invalid Shortcut Argument: the "-c" argument is not a valid option'
    (->
      app.parse ['-c', 'a value']
    ).should.throw 'Invalid Shortcut Argument: the "-c" argument is not a valid option'

  it 'throw error for an undeclared shortcut in command', ->
    # Test a boolean (no value) argument
    app = parameters
      commands: 'server': commands: 'start': {}
    (->
      app.parse ['server', 'start', '-c']
    ).should.throw 'Invalid Shortcut Argument: the "-c" argument is not a valid option in command "server start"'
    (->
      app.parse ['server', 'start', '-c', 'a value']
    ).should.throw 'Invalid Shortcut Argument: the "-c" argument is not a valid option in command "server start"'

  it 'handle help shortcut', ->
    # Test a boolean (no value) argument
    parameters()
    .parse ['-h']
    .help.should.be.True()
