
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
        'start': {}
    .help('start').should.match /myapp start - No description yet/

  it 'command array', ->
    
    parameters
      commands:
        'start': {}
    .help(['start']).should.match /myapp start - No description yet/

  describe 'params object', ->

    it 'help isnt requested, return null', ->
      should.not.exist(
        parameters
          commands: 'start': {}
        .help
          command: 'start'
      )
      should.not.exist(
        parameters
          commands: 'start': {}
        .help
          command: ['start', 'sth']
      )

    it 'display help of the app', ->
      # With an options
      parameters()
      .help
        help: true
      .should.match /myapp - No description yet/

    it 'display help of a command with --help option', ->
      # With an options
      parameters
        commands: 'start': {}
      .help
        help: true
        command: 'start'
      .should.match /myapp start - No description yet/
