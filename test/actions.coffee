
should = require 'should'
parameters = require "../#{if process.env.PARAMETERS_COV then 'lib-cov' else 'src'}"

describe 'with actions', ->

  it 'accept no main and no option', ->
    params = parameters
      actions: [name: 'start']
    params.decode(['node', 'myscript', 'start']).should.eql
      action: 'start'
    params.encode
      action: 'start'
    .should.eql ['start']

  it 'accept no main and a string option', ->
    params = parameters actions: [
      name: 'start'
      options: [
        name: 'myparam'
      ]
    ]
    params.decode(['node', 'myscript', 'start', '--myparam', 'my value']).should.eql
      action: 'start'
      myparam: 'my value'
    params.encode
      action: 'start'
      myparam: 'my value'
    .should.eql ['start', '--myparam', 'my value']

  it 'accept an optional main and no option', ->
    params = parameters actions: [
      name: 'start'
      main:
        name: 'command'
    ]
    params.decode(['node', 'myscript', 'start', 'my --command']).should.eql
      action: 'start'
      command: 'my --command'
    params.decode(['node', 'myscript', 'start']).should.eql
      action: 'start'
    params.encode
      action: 'start'
      command: 'my --command'
    .should.eql ['start', 'my --command']
    params.encode
      action: 'start'
    .should.eql ['start']

  it 'throw error if action is undefined', ->
    params = parameters actions: [name: 'myaction']
    (->
      params.decode ['node', 'myscript', 'hum', '-s', 'my', '--command']
    ).should.throw "Invalid action 'hum'"
    (->
      params.encode 
        action: 'hum'
        myparam: true
    ).should.throw "Invalid action 'hum'"
