
parameters = require '../src'

describe 'main.required', ->

  it 'may be optional', ->
    app = parameters commands: [
      name: 'mycommand'
      main:
        name: 'my_argument'
    ]
    app.parse [
      'mycommand'
    ]
    .should.eql
      command: ['mycommand']
    app.stringify
      command: ['mycommand']
    .should.eql ['mycommand']

  it 'honors required true if value is provided', ->
    app = parameters commands: [
      name: 'mycommand'
      main:
        name: 'my_argument'
        required: true
    ]
    app.parse [
      'mycommand', 'my --value'
    ]
    .should.eql
      command: ['mycommand']
      my_argument: ['my --value']
    app.stringify
      command: ['mycommand']
      my_argument: ['my --value']
    .should.eql ['mycommand', 'my --value']

  it 'honors required true if no value provided', ->
    app = parameters commands: [
      name: 'mycommand'
      main:
        name: 'my_argument'
        required: true
    ]
    (->
      app.parse 'mycommand'
    ).should.throw 'Required Main Argument: no suitable arguments for "my_argument"'
    (->
      app.stringify
        command: ['mycommand']
    ).should.throw 'Required Main Parameter: no suitable arguments for "my_argument"'
