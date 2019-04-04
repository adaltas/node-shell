
parameters = require '../src'

describe 'api.help_arguments', ->

  it 'is empty', ->
    parameters
      commands:
        'start': {}
    .help().should.match /myapp - No description yet/

  it 'command string', ->
    parameters
      commands:
        'server':
          commands:
            'start': {}
    .help('server start').should.match /myapp server start - No description yet/

  it 'command array', ->
    parameters
      commands:
        'start': {}
    .help(['start']).should.match /myapp start - No description yet/

  it 'throw error if parameters match an undefined command', ->
    (->
      parameters
        commands: 'start': {}
      .help ['start', 'sth']
    ).should.throw 'Invalid Command: "start sth"'