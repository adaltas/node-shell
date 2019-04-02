
parameters = require '../src'
  
describe 'options.strict', ->

  it 'throw error for an undefined argument', ->
    app = parameters strict: true
    (->
      app.parse ['--myoption', 'my', '--command']
    ).should.throw 'Invalid option "myoption"'
    (->
      app.stringify
        myoption: true
    ).should.throw 'Invalid option "myoption"'

  it 'throw error for an undefined shortcut', ->
    # Test a boolean (no value) argument
    app = parameters strict: true
    (->
      app.parse ['-c']
    ).should.throw 'Invalid Shortcut: "-c"'

  it 'throw error for an undefined argument inside an command', ->
    app = parameters strict: true, commands: [name: 'mycommand']
    (->
      app.parse ['mycommand', '--myoption', 'my', '--command']
    ).should.throw 'Invalid option "myoption"'
    (->
      app.stringify
        command: 'mycommand'
        myoption: true
    ).should.throw 'Invalid option "myoption"'

  it 'throw error for an undefined shortcut inside an command', ->
    # Test a boolean (no value) argument
    app = parameters strict: true, commands: [name: 'mycommand']
    (->
      app.parse ['mycommand', '-c']
    ).should.throw 'Invalid Shortcut: "-c" in command "mycommand"'
