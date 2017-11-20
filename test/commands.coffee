
parameters = require '../src'

describe 'commands', ->

  it 'accept no main and no option', ->
    params = parameters
      commands: [name: 'start']
    params.parse(['start']).should.eql
      command: 'start'
    params.stringify
      command: 'start'
    .should.eql ['start']

  it 'command is of type object', ->
    params = parameters
      commands: 'start': {}
    params.parse(['start']).should.eql
      command: 'start'
    params.stringify
      command: 'start'
    .should.eql ['start']

  it 'options is of type array', ->
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

  it 'options is of type object', ->
    params = parameters
      commands:
        'start':
          options:
            myparam: {}
    params.parse(['start', '--myparam', 'my value']).should.eql
      command: 'start'
      myparam: 'my value'
    params.stringify
      command: 'start'
      myparam: 'my value'
    .should.eql ['start', '--myparam', 'my value']

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
