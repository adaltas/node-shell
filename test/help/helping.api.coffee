
parameters = require '../../src'

describe 'help/helping.api', ->
  
  it 'flatten expect an object', ->
    (->
      parameters()
      .helping 'invalid'
    ).should.throw 'Invalid Arguments: `helping` expect a params object as first argument in flatten mode, got "invalid"'
  
  it 'extended expect an array of objects', ->
    (->
      parameters extended: true
      .helping ['invalid']
    ).should.throw 'Invalid Arguments: `helping` expect a params array with literal objects as first argument in extended mode, got ["invalid"]'

  it 'ensure command is an array in flatten mode', ->
    (->
      parameters
        commands: 'start': commands: 'server': {}
      .helping
        command: 'help'
        name: 'start'
    ).should.throw 'Invalid Arguments: parameter "command" must be an array in flatten mode, got "help"'
  
