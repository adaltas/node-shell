
parameters = require '../src'

describe 'api.stringify', ->

  it 'validate', ->
    (->
      parameters()
      .stringify {}, 'invalid'
    ).should.throw 'Invalid Arguments: 2nd argument option must be an object, got "invalid"'
