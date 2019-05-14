
parameters = require '../src'

describe 'api.compile', ->

  it 'validate', ->
    (->
      parameters()
      .compile {}, 'invalid'
    ).should.throw 'Invalid Compile Arguments: 2nd argument option must be an object, got "invalid"'
  
  it 'command string is converted to a 1 element array internally', ->
    parameters
      commands: 'start': {}
    .compile command: 'start'
    .should.eql ['start']
    
  it 'catch main argument with type of string', ->
    (->
      parameters
        main: 'leftover'
      .compile
        leftover: 'my value'
    ).should.throw 'Invalid Parameter Type: expect main to be an array, got "my value"'
  
  it 'check a command is registered', ->
    (->
      parameters
        commands:
          'start': {}
          'stop': {}
      .compile
        command: ['status']
    ).should.throw 'Invalid Command Parameter: command "status" is not registed, expect one of ["help","start","stop"]'
    (->
      parameters
        commands: 'server': commands:
          'start': {}
          'stop': {}
      .compile
        command: ['server', 'status']
    ).should.throw 'Invalid Command Parameter: command "status" is not registed, expect one of ["start","stop"] in command "server"'
