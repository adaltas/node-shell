
parameters = require '../src'

describe 'help', ->

  it 'handle an empty command as help', ->
    params = parameters commands: [name: 'help']
    params.parse([]).should.eql
      command: 'help'

  it 'handle an empty command as even if help is not defined', ->
    params = parameters commands: [name: 'fake']
    params.parse([]).should.eql
      command: 'help'

  it 'global options without a command', ->
    params = parameters commands: [name: 'fake']
    params.parse(['--param', 'value']).should.eql
      param: 'value'
      command: 'help'

  it 'handle help command', ->
    params = parameters commands: [name: 'help']
    params.parse(['help']).should.eql
      command: 'help'
    params.stringify
      command: 'help'
    .should.eql ['help']

  it 'handle help command with a command', ->
    params = parameters commands: [name: 'toto']
    params.parse(['help', 'start']).should.eql
      command: 'help'
      name: 'start'
    params.stringify
      command: 'help'
      name: 'start'
    .should.eql ['help', 'start']

  describe 'without command', ->

    it 'should print multiple options', ->
      params = parameters
        name: 'myscript'
        description: 'Some description for myscript'
        main: 
          name: 'command'
          description: 'Command in start' 
        options: [
          name: 'string'
          shortcut: 's'
          description: 'String option in start'
        ,
          name: 'boolean'
          shortcut: 'b'
          type: 'boolean'
          description: 'Boolean option in start'
        ,
          name: 'integer'
          shortcut: 'i'
          type: 'integer'
          description: 'Integer option in start'
        ]
      params.help().should.eql """
      NAME
          myscript - Some description for myscript
      SYNOPSIS
          myscript [options...]
      DESCRIPTION
          -s --string         String option in start
          -b --boolean        Boolean option in start
          -i --integer        Integer option in start
          -h --help           Display help information
          command             Command in start
      EXAMPLES
          myscript --help     Show this message

      """

    it 'should bypass required', ->
      params = parameters
        name: 'myscript'
        description: 'Some description for myscript'
        options: [
          name: 'myarg'
          description: 'MyArg'
          required: true
        ]
      params.parse(['--help']).help.should.be.True
      params.help().should.eql """
      NAME
          myscript - Some description for myscript
      SYNOPSIS
          myscript [options...]
      DESCRIPTION
          --myarg             MyArg
          -h --help           Display help information
      EXAMPLES
          myscript --help     Show this message

      """

  describe 'with command', ->

    it 'should print multiple commands with multiple options', ->
      params = parameters
        name: 'myscript'
        description: 'Some description for myscript'
        commands: [
          name: 'start'
          description: 'Description for the start command'
          main: 
            name: 'command'
            description: 'Command in start' 
          options: [
            name: 'string'
            shortcut: 's'
            description: 'String option in start'
          ,
            name: 'boolean'
            shortcut: 'b'
            type: 'boolean'
            description: 'Boolean option in start'
          ,
            name: 'integer'
            shortcut: 'i'
            type: 'integer'
            description: 'Integer option in start'
          ]
        ,
          name: 'stop'
          description: 'Description for the stop command'
          main:
            name: 'command'
            description: 'Command in stop'
          options: [
            name: 'string'
            shortcut: 's'
            description: 'String option in stop'
          ,
            name: 'boolean'
            shortcut: 'b'
            description: 'Boolean option in stop'
          ]
        ]
      params.help().should.eql """
      NAME
          myscript - Some description for myscript
      SYNOPSIS
          myscript command [options...]
          where command is one of
            start             Description for the start command
            stop              Description for the stop command
            help              Display help information about myscript
      DESCRIPTION
          start               Description for the start command
            -s --string         String option in start
            -b --boolean        Boolean option in start
            -i --integer        Integer option in start
            command             Command in start
          stop                Description for the stop command
            -s --string         String option in stop
            -b --boolean        Boolean option in stop
            command             Command in stop
          help                Display help information about myscript
            name                Help about a specific command
      EXAMPLES
          myscript help       Show this message

      """
      params.help().should.eql params.help 'help'

    it 'describe an command', ->
      params = parameters
        name: 'myscript'
        description: 'Some description for myscript'
        commands:[
          name: 'start'
          description: 'Description for the start command'
          main: 
            name: 'command'
            description: 'Command in start' 
          options: [
            name: 'string'
            shortcut: 's'
            description: 'String option in start'
          ]
        ]
      params.help('start').should.eql """
      NAME
          myscript start - Description for the start command
      SYNOPSIS
          myscript start [options...] [command]
      DESCRIPTION
          start               Description for the start command
            -s --string         String option in start
            command             Command in start

      """

    it 'error if command isnt defined', ->
      params = parameters
        name: 'myscript'
        commands:[]
      try
        params.help('undefined')
      catch e then e.message.should.eql 'Invalid command "undefined"'

    it 'display main without braket if required', ->
      params = parameters
        name: 'myscript'
        description: 'Some description for myscript'
        commands: [
          name: 'start'
          description: 'Description for the start command'
          main: 
            name: 'command'
            description: 'Command in start'
            required: true
        ]
      params.help('start').should.eql """
      NAME
          myscript start - Description for the start command
      SYNOPSIS
          myscript start command
      DESCRIPTION
          start               Description for the start command
            command             Command in start

      """

    it 'display options without brakets at least one required', ->
      params = parameters
        name: 'myscript'
        description: 'Some description for myscript'
        commands: [
          name: 'start'
          description: 'Description for the start command'
          options: [
            name: 'optional'
            shortcut: 'o'
            description: 'Optional option'
          ,
            name: 'required'
            shortcut: 'r'
            description: 'Required option'
            required: true
          ]
        ]
      params.help('start').should.eql """
      NAME
          myscript start - Description for the start command
      SYNOPSIS
          myscript start options...
      DESCRIPTION
          start               Description for the start command
            -o --optional       Optional option
            -r --required       Required option

      """
