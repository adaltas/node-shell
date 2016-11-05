
should = require 'should'
parameters = require '../src'

describe 'options required', ->

  it 'in main', ->
    params = parameters commands: [
      name: 'mycommand'
      main: 
        name: 'my_argument'
        required: true
    ]
    params.parse(['mycommand', 'my --value']).should.eql
      command: 'mycommand'
      my_argument: 'my --value'
    (->
      params.parse ['mycommand']
    ).should.throw 'Required main argument "my_argument"'
    params.stringify
      command: 'mycommand'
      my_argument: 'my --value'
    .should.eql ['mycommand', 'my --value']
    (->
      params.stringify
        command: 'mycommand'
    ).should.throw 'Required main argument "my_argument"'
