
parameters = require '../src'

describe 'main.required', ->

  it 'may be optional', ->
    params = parameters commands: [
      name: 'mycommand'
      main: 
        name: 'my_argument'
    ]
    params.parse(['mycommand']).should.eql
      command: 'mycommand'
    params.stringify 
      command: 'mycommand'
    .should.eql ['mycommand']

  it 'honors required true if value is provided', ->
    params = parameters commands: [
      name: 'mycommand'
      main: 
        name: 'my_argument'
        required: true
    ]
    params.parse(['mycommand', 'my --value']).should.eql
      command: 'mycommand'
      my_argument: 'my --value'
    params.stringify
      command: 'mycommand'
      my_argument: 'my --value'
    .should.eql ['mycommand', 'my --value']

  it 'honors required true if no value provided', ->
    params = parameters commands: [
      name: 'mycommand'
      main: 
        name: 'my_argument'
        required: true
    ]
    (->
      params.parse ['mycommand']
    ).should.throw 'Required main argument "my_argument"'
    (->
      params.stringify
        command: 'mycommand'
    ).should.throw 'Required main argument "my_argument"'
