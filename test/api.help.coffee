
parameters = require '../src'

describe 'api.help', ->

  describe 'without command', ->
    
    it 'minimalist, no name, no description, no options, no main', ->
      parameters {}
      .help().should.eql """
      
      NAME
          myapp - No description yet
      
      SYNOPSIS
          myapp
      
      OPTIONS
          -h --help               Display help information
      
      EXAMPLES
          myapp --help            Show this message
      
      """

    
    it 'print without a name and a description', ->
      parameters()
      .help().should.eql """

      NAME
          myapp - No description yet

      SYNOPSIS
          myapp

      OPTIONS
          -h --help               Display help information

      EXAMPLES
          myapp --help            Show this message

      """

    it 'print multiple options', ->
      parameters
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
      .help().should.eql """

      NAME
          myscript - Some description for myscript

      SYNOPSIS
          myscript [myscript options] {command}

      OPTIONS
          -s --string             String option in start
          -b --boolean            Boolean option in start
          -i --integer            Integer option in start
          -h --help               Display help information
          command                 Command in start

      EXAMPLES
          myscript --help         Show this message

      """

    it 'bypass required', ->
      params = parameters
        name: 'myscript'
        description: 'Some description for myscript'
        options: [
          name: 'myarg'
          description: 'MyArg'
          required: true
        ]
      params.parse(['--help']).help.should.be.True()
      params.help().should.eql """

      NAME
          myscript - Some description for myscript

      SYNOPSIS
          myscript [myscript options]

      OPTIONS
          --myarg                 MyArg Required.
          -h --help               Display help information

      EXAMPLES
          myscript --help         Show this message

      """

  describe 'with command', ->

    it 'error if command isnt defined', ->
      params = parameters
        name: 'myscript'
        commands: []
      ( ->
        params.help('undefined')
      ).should.throw 'Invalid Command: "undefined"'
        
    it 'minimalist, no name, no description, no options, no main', ->
      parameters
        commands:
          'start': {}
      .help().should.eql """

      NAME
          myapp - No description yet

      SYNOPSIS
          myapp <command>

      OPTIONS
          -h --help               Display help information

      COMMANDS
          start                   No description yet for the start command
          help                    Display help information about myapp

      COMMAND "start"
          start                   No description yet for the start command

      COMMAND "help"
          help                    Display help information about myapp
          help {name}             Help about a specific command

      EXAMPLES
          myapp --help            Show this message
          myapp help              Show this message

      """

    it 'print all commands with multiple options', ->
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
            name: 'array'
            shortcut: 'a'
            description: 'Array option in stop'
          ]
        ]
      params.help().should.eql """

      NAME
          myscript - Some description for myscript

      SYNOPSIS
          myscript <command>

      OPTIONS
          -h --help               Display help information

      COMMANDS
          start                   Description for the start command
          stop                    Description for the stop command
          help                    Display help information about myscript

      COMMAND "start"
          start                   Description for the start command
          start {command}         Command in start

      COMMAND "stop"
          stop                    Description for the stop command
          stop {command}          Command in stop

      COMMAND "help"
          help                    Display help information about myscript
          help {name}             Help about a specific command

      EXAMPLES
          myscript --help         Show this message
          myscript help           Show this message

      """
      # params.help().should.eql params.help 'help'

    it 'describe a specific command', ->
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
      expect = """

      NAME
          myscript start - Description for the start command

      SYNOPSIS
          myscript start [start options] {command}

      OPTIONS for start
          -s --string             String option in start
          -h --help               Display help information
          command                 Command in start
      
      OPTIONS for myscript
          -h --help               Display help information

      EXAMPLES
          myscript start --help   Show this message

      """
      params.help('start').should.eql expect
      params.help(['start']).should.eql expect
      params.help(command: 'help', name: 'start').should.eql expect

  describe 'with nested command', ->

    it 'error if command isnt defined', ->
      params = parameters
        name: 'myscript'
        commands: [
          name: 'mycommand'
        ]
      ( ->
        params.help('mycommand', 'undefined')
      ).should.throw 'Invalid Command: "mycommand undefined"'

    it.skip 'display options without brakets at least one required', ->
      params = parameters
        name: 'myscript'
        description: 'Some description for myscript'
        options: [
          name: 'root_opt'
        ,
          name: 'root_opt_w_sht'
          shortcut: 'c'
        ,
          name: 'root_opt_rqd'
          required: true
        ]
        commands: [
          name: 'parent'
          options: [
            name: 'parent_opt'
          ,
            name: 'parent_opt_w_sht'
            shortcut: 'c'
          ,
            name: 'parent_opt_rqd'
            required: true
          ]
          commands: [
            name: 'child'
            options: [
              name: 'child_opt'
            ,
              name: 'child_opt_w_sht'
              shortcut: 'c'
            ,
              name: 'child_opt_rqd'
              required: true
            ]
            main:
              name: 'action'
          ]
        ]
      params.help('parent') # , 'child'
