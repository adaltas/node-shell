
parameters = require '../src'

describe 'api.helping', ->
  
  describe 'validation', ->
  
    it 'flatten expect an object', ->
      (->
        parameters()
        .helping 'invalid'
      ).should.throw 'Invalid Arguments: `helping` expect a params object as first argument in flatten mode, got "invalid"'
    
    it 'extended expect an array of objects', ->
      (->
        parameters extended: true
        .helping ['invalid']
      ).should.throw 'Invalid Arguments: `helping` expect a params array with literal objects as first argument in extended mode, got ["invalid"]'

    it 'ensure command is an array in flatten mode', ->
      (->
        parameters
          commands: 'start': commands: 'server': {}
        .helping
          command: 'help'
          name: 'start'
      ).should.throw 'Invalid Arguments: parameter "command" must be an array in flatten mode, got "help"'
  
  describe 'help is not requested', ->

    it 'help command only in extended mode', ->
      helping = parameters
        commands: 'start': {}
        extended: true
      .helping [{}]
      (helping is null).should.be.true()

  describe 'command help not followed by a command', ->
    
    it 'in flatten mode', ->
      parameters
        commands: 'start': {}
      .helping
        command: ['help']
      .should.eql []
    
    it 'in extended mode', ->
      parameters
        commands: 'start': {}
        extended: true
      .helping [{},
        command: 'help'
      ]
      .should.eql []
  
  describe 'command help followed by a command name', ->

    it 'in flatten mode', ->
      parameters
        commands: 'start': commands: 'server': {}
      .helping
        command: ['help']
        name: 'start'
      .should.eql ['start']

    it 'in extended mode', ->
      parameters
        commands: 'start': commands: 'server': {}
        extended: true
      .helping [ {},
        command: 'help'
        name: 'start'
      ]
      .should.eql ['start']
  
  describe 'option in application level', ->

    it 'no help option in flatten mode', ->
      should.not.exist(
        parameters {}
        .helping
          my_opt: true
      )

    it 'no help option in extended mode', ->
      should.not.exist(
        parameters extended: true
        .helping [
          my_opt: true
        ]
      )

    it 'in flatten mode', ->
      parameters {}
      .helping
        help: true
      .should.eql []

    it 'in extended mode', ->
      parameters extended: true
      .helping [
        help: true
      ]
      .should.eql []
  
  describe 'option in command level', ->

    it 'no help option in flatten mode', ->
      should.not.exist(
        parameters
          commands: 'server':
            options: 'my_opt_1': {}
            commands: 'start':
              options: 'my_opt_2': {}
              commands: 'app': {}
        .helping
          command: ['server', 'start']
          my_opt_1: true
          my_opt_2: true
      )

    it 'no help option in extended mode', ->
      should.not.exist(
        parameters
          commands: 'server':
            options: 'my_opt_1': {}
            commands: 'start':
              options: 'my_opt_2': {}
              commands: 'app': {}
          extended: true
        .helping [{},
          command: 'server'
          my_opt_1: true
        ,
          command: 'start'
          my_opt_2: true
        ]
      )

    it 'with help options in the middle of subcommand in flatten mode', ->
      # Flatten mode
      parameters
        commands: 'server': commands: 'start': {}
      .helping
        command: ['server']
        help: true
      .should.eql ['server']

    it 'with help options in the middle of subcommand in extended mode', ->
      parameters
        commands: 'server': commands: 'start': {}
        extended: true
      .helping [ {},
        command: 'server'
        help: true
      ]
      .should.eql ['server']

    it 'throw Error if help in not associated with the last command in extended mode', ->
      (->
        parameters
          commands: 'server': commands: 'start': {}
          extended: true
        .helping [ {},
          command: 'server'
          help: true
        ,
          command: 'start'
        ]
      ).should.throw 'Invalid Argument: `help` must be associated with a leaf command'

    it 'with help options at the end of subcommand in flatten mode', ->
      parameters
        commands: 'server': commands: 'start': {}
      .helping
        command: ['server', 'start']
        help: true
      .should.eql ['server', 'start']

    it 'with help options at the end of subcommand in extended mode', ->
      parameters
        commands: 'server': commands: 'start': {}
        extended: true
      .helping [ {},
        command: 'server'
      ,
        command: 'start'
        help: true
      ]
      .should.eql ['server', 'start']
