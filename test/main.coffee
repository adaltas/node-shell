
should = require 'should'
parameters = require '../src'

describe 'main', ->

  it 'may follow command without any option', ->
    params = parameters commands: [
      name: 'mycommand'
      main: 
        name: 'my_argument'
        required: true
    ]
    params.parse(['mycommand', 'my value']).should.eql
      command: 'mycommand'
      my_argument: 'my value'
    params.stringify 
      command: 'mycommand'
      my_argument: 'my value'
    .should.eql ['mycommand', 'my value']

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

  it 'work with no option', ->
    params = parameters
      main:
        name: 'my_argument'
    params.parse(['my --command']).should.eql
      my_argument: 'my --command'
    params.parse([]).should.eql {}
    params.stringify 
      my_argument: 'my --command'
    .should.eql ['my --command']
    params.stringify({}).should.eql []
