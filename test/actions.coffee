
should = require 'should'
parameters = require "../#{if process.env.PARAMETERS_COV then 'lib-cov' else 'src'}"

describe 'commands', ->

  it 'accept no main and no option', ->
    params = parameters
      commands: [name: 'start']
    params.parse(['start']).should.eql
      command: 'start'
    params.stringify
      command: 'start'
    .should.eql ['start']

  it 'accept no main and a string option', ->
    params = parameters commands: [
      name: 'start'
      options: [
        name: 'myparam'
      ]
    ]
    params.parse(['start', '--myparam', 'my value']).should.eql
      command: 'start'
      myparam: 'my value'
    params.stringify
      command: 'start'
      myparam: 'my value'
    .should.eql ['start', '--myparam', 'my value']

  it 'accept an optional main and no option', ->
    params = parameters commands: [
      name: 'start'
      main:
        name: 'commanda'
    ]
    params.parse(['start', 'my --command']).should.eql
      command: 'start'
      commanda: 'my --command'
    params.parse(['start']).should.eql
      command: 'start'
    params.stringify
      command: 'start'
      commanda: 'my --command'
    .should.eql ['start', 'my --command']
    params.stringify
      command: 'start'
    .should.eql ['start']

  it 'throw error if command is undefined', ->
    params = parameters commands: [name: 'myaction']
    (->
      params.parse ['hum', '-s', 'my', '--command']
    ).should.throw "Invalid command 'hum'"
    (->
      params.stringify 
        command: 'hum'
        myparam: true
    ).should.throw "Invalid command 'hum'"

  it 'throw error if no main and command provide extra arguments', ->
    # Command with no option
    params = parameters commands: [name: 'mycommand']
    (->
      params.parse ['mycommand', 'mymain']
    ).should.throw "Fail to parse end of command \"mymain\""
    # Command with one option
    params = parameters commands: [name: 'mycommand', options: [name:'arg']]
    (->
      params.parse ['mycommand', '--arg', 'myarg', 'mymain']
    ).should.throw "Fail to parse end of command \"mymain\""

  it 'customize command name', ->
    params = parameters
      command: 'mycommand'
      commands: [name: 'start']
    params.parse(['start']).should.eql
      mycommand: 'start'
    params.stringify
      mycommand: 'start'
    .should.eql ['start']

  it 'mix with general options', ->
    params = parameters
      options: [
        name: 'gopt'
      ]
      commands: [
        name: 'start'
        options: [
          name: 'aopt'
        ]
      ]
    params.parse(['--gopt', 'toto', 'start', '--aopt', 'lulu']).should.eql
      gopt: 'toto'
      command: 'start'
      aopt: 'lulu'
    params.stringify
      gopt: 'toto'
      command: 'start'
      aopt: 'lulu'
    .should.eql ['--gopt', 'toto', 'start', '--aopt', 'lulu']

