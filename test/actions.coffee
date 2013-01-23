
should = require 'should'
parameters = require "../#{if process.env.PARAMETERS_COV then 'lib-cov' else 'src'}"

describe 'with actions', ->

  it 'accept no main and no option', ->
    params = parameters
      actions: [name: 'start']
    params.parse(['start']).should.eql
      action: 'start'
    params.stringify
      action: 'start'
    .should.eql ['start']

  it 'accept no main and a string option', ->
    params = parameters actions: [
      name: 'start'
      options: [
        name: 'myparam'
      ]
    ]
    params.parse(['start', '--myparam', 'my value']).should.eql
      action: 'start'
      myparam: 'my value'
    params.stringify
      action: 'start'
      myparam: 'my value'
    .should.eql ['start', '--myparam', 'my value']

  it 'accept an optional main and no option', ->
    params = parameters actions: [
      name: 'start'
      main:
        name: 'command'
    ]
    params.parse(['start', 'my --command']).should.eql
      action: 'start'
      command: 'my --command'
    params.parse(['start']).should.eql
      action: 'start'
    params.stringify
      action: 'start'
      command: 'my --command'
    .should.eql ['start', 'my --command']
    params.stringify
      action: 'start'
    .should.eql ['start']

  it 'throw error if action is undefined', ->
    params = parameters actions: [name: 'myaction']
    (->
      params.parse ['hum', '-s', 'my', '--command']
    ).should.throw "Invalid action 'hum'"
    (->
      params.stringify 
        action: 'hum'
        myparam: true
    ).should.throw "Invalid action 'hum'"
