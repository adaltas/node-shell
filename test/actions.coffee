
should = require 'should'
parameters = require "../#{if process.env.PARAMETERS_COV then 'lib-cov' else 'src'}"

describe 'actions', ->

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
        name: 'commanda'
    ]
    params.parse(['start', 'my --command']).should.eql
      action: 'start'
      commanda: 'my --command'
    params.parse(['start']).should.eql
      action: 'start'
    params.stringify
      action: 'start'
      commanda: 'my --command'
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

  it 'throw error if no main and command provide extra arguments', ->
    # Action with no option
    params = parameters actions: [name: 'myaction']
    (->
      params.parse ['myaction', 'mymain']
    ).should.throw "Fail to parse end of command \"mymain\""
    # Action with one option
    params = parameters actions: [name: 'myaction', options: [name:'arg']]
    (->
      params.parse ['myaction', '--arg', 'myarg', 'mymain']
    ).should.throw "Fail to parse end of command \"mymain\""

  it 'customize action name', ->
    params = parameters
      action: 'myaction'
      actions: [name: 'start']
    params.parse(['start']).should.eql
      myaction: 'start'
    params.stringify
      myaction: 'start'
    .should.eql ['start']

  it 'mix with general options', ->
    params = parameters
      options: [
        name: 'gopt'
      ]
      actions: [
        name: 'start'
        options: [
          name: 'aopt'
        ]
      ]
    params.parse(['--gopt', 'toto', 'start', '--aopt', 'lulu']).should.eql
      gopt: 'toto'
      action: 'start'
      aopt: 'lulu'
    params.stringify
      gopt: 'toto'
      action: 'start'
      aopt: 'lulu'
    .should.eql ['--gopt', 'toto', 'start', '--aopt', 'lulu']

