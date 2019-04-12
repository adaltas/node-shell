
parameters = require '../src'

describe 'api.stringify', ->

  it 'validate', ->
    (->
      parameters()
      .stringify {}, 'invalid'
    ).should.throw 'Invalid Stringify Arguments: 2nd argument option must be an object, got "invalid"'
  
  it 'command string is converted to a 1 element array internally', ->
    parameters
      commands: [
        name: 'start'
      ]
    .stringify command: 'start'
    .should.eql ['start']
    
  it 'catch main argument with type of string', ->
    (->
      parameters
        main: 'leftover'
      .stringify
        leftover: 'my value'
    ).should.throw 'Invalid Parameter Type: expect main to be an array, got "my value"'
  
  it 'check a command is registered', ->
    (->
      parameters
        commands:
          'start': {}
          'stop': {}
      .stringify
        command: ['status']
    ).should.throw 'Invalid Command Parameter: command "status" is not registed, expect one of ["help","start","stop"]'
    (->
      parameters
        commands: 'server': commands:
          'start': {}
          'stop': {}
      .stringify
        command: ['server', 'status']
    ).should.throw 'Invalid Command Parameter: command "status" is not registed, expect one of ["start","stop"] in command "server"'
