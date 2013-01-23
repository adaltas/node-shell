
should = require 'should'
parameters = require "../#{if process.env.PARAMETERS_COV then 'lib-cov' else 'src'}"

describe 'main', ->

  it 'may follow action without any option', ->
    params = parameters actions: [
      name: 'myaction'
      main: 
        name: 'command'
        required: true
    ]
    params.parse(['node', 'myscript', 'myaction', 'mycommand']).should.eql
      action: 'myaction'
      command: 'mycommand'
    params.stringify 
      action: 'myaction'
      command: 'mycommand'
    .should.eql ['myaction', 'mycommand']

  it 'may be optional', ->
    params = parameters actions: [
      name: 'myaction'
      main: 
        name: 'command'
    ]
    params.parse(['node', 'myscript', 'myaction']).should.eql
      action: 'myaction'
    params.stringify 
      action: 'myaction'
    .should.eql ['myaction']

  it 'may be required', ->
    params = parameters actions: [
      name: 'myaction'
      main: 
        name: 'command'
        required: true
    ]
    params.parse(['node', 'myscript', 'myaction', 'my --command']).should.eql
      action: 'myaction'
      command: 'my --command'
    (->
      params.parse ['node', 'myscript', 'myaction']
    ).should.throw 'Required main argument "command"'
    params.stringify
      action: 'myaction'
      command: 'my --command'
    .should.eql ['myaction', 'my --command']
    (->
      params.stringify
        action: 'myaction'
    ).should.throw 'Required main argument "command"'

  it 'work with no option', ->
    params = parameters
      main:
        name: 'command'
    params.parse(['node', 'myscript', 'my --command']).should.eql
      command: 'my --command'
    params.parse(['node', 'myscript']).should.eql {}
    params.stringify 
      command: 'my --command'
    .should.eql ['my --command']
    params.stringify({}).should.eql []