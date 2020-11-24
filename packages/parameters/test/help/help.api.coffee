
shell = require '../../src'

describe 'help/help.api', ->

  it 'is empty', ->
    shell
      commands:
        'start': {}
    .help().should.match /myapp - No description yet/

  it 'command string', ->
    shell
      commands:
        'server':
          commands:
            'start': {}
    .help('server start').should.match /myapp server start - No description yet/

  it 'command array', ->
    shell
      commands:
        'start': {}
    .help(['start']).should.match /myapp start - No description yet/

  it 'throw error if shell match an undefined command', ->
    (->
      shell
        commands: 'start': {}
      .help ['start', 'sth']
    ).should.throw 'Invalid Command: argument "start sth" is not a valid command'
