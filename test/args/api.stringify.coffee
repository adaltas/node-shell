
parameters = require '../../src'

describe 'api.stringify', ->

  it 'should convert a parameters object to a command string', ->
    parameters
      commands: 'start':
        options: 'myparam': {}
    .stringify
      command: 'start'
      myparam: 'my value'
    .should.eql 'start --myparam "my value"'
