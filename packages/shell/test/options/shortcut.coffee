
shell = require '../../lib'
  
describe 'options.shortcut', ->

  it 'throw error for an undeclared shortcut', ->
    # Test a boolean (no value) argument
    app = shell()
    (->
      app.parse ['-c']
    ).should.throw 'Invalid Shortcut Argument: the "-c" argument is not a valid option'
    (->
      app.parse ['-c', 'a value']
    ).should.throw 'Invalid Shortcut Argument: the "-c" argument is not a valid option'

  it 'throw error for an undeclared shortcut in command', ->
    # Test a boolean (no value) argument
    app = shell
      commands: 'server': commands: 'start': {}
    (->
      app.parse ['server', 'start', '-c']
    ).should.throw 'Invalid Shortcut Argument: the "-c" argument is not a valid option in command "server start"'
    (->
      app.parse ['server', 'start', '-c', 'a value']
    ).should.throw 'Invalid Shortcut Argument: the "-c" argument is not a valid option in command "server start"'

  it 'handle help shortcut', ->
    # Test a boolean (no value) argument
    shell()
    .parse ['-h']
    .help.should.be.True()
