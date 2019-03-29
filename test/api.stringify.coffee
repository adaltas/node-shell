
parameters = require '../src'

describe 'api.stringify', ->

  it 'validate', ->
    (->
      parameters()
      .stringify {}, 'invalid'
    ).should.throw 'Invalid Arguments: 2nd argument option must be an object, got "invalid"'
  
  it 'command string is converted to a 1 element array internally', ->
    parameters
      commands: [
        name: 'start'
      ]
    .stringify command: 'start'
    .should.eql ['start']
