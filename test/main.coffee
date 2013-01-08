
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
    params.decode(['node', 'myscript', 'myaction', 'mycommand']).should.eql
      action: 'myaction'
      command: 'mycommand'
    params.encode 
      action: 'myaction'
      command: 'mycommand'
    .should.eql ['myaction', 'mycommand']

  it 'may be optional', ->
    params = parameters actions: [
      name: 'myaction'
      main: 
        name: 'command'
    ]
    params.decode(['node', 'myscript', 'myaction']).should.eql
      action: 'myaction'
    params.encode 
      action: 'myaction'
    .should.eql ['myaction']

  it 'may be required', ->
    params = parameters actions: [
      name: 'myaction'
      main: 
        name: 'command'
        required: true
    ]
    params.decode(['node', 'myscript', 'myaction', 'my --command']).should.eql
      action: 'myaction'
      command: 'my --command'
    (->
      params.decode ['node', 'myscript', 'myaction']
    ).should.throw 'Required main argument "command"'
    params.encode
      action: 'myaction'
      command: 'my --command'
    .should.eql ['myaction', 'my --command']
    (->
      params.encode
        action: 'myaction'
    ).should.throw 'Required main argument "command"'

  it 'work with no option', ->
    params = parameters
      main:
        name: 'command'
    params.decode(['node', 'myscript', 'my --command']).should.eql
      command: 'my --command'
    params.decode(['node', 'myscript']).should.eql {}
    params.encode 
      command: 'my --command'
    .should.eql ['my --command']
    params.encode({}).should.eql []