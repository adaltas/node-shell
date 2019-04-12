
parameters = require '../src'

describe 'help.shortcut', ->

  describe 'without command', ->

    it 'should print without shortcut', ->
      parameters
        name: 'myscript'
        description: 'Some description for myscript'
        options: [
          name: 'myarg'
          description: 'MyArg'
        ]
      .help()
      .should.eql """
      
      NAME
          myscript - Some description for myscript

      SYNOPSIS
          myscript [myscript options]

      OPTIONS
          --myarg                 MyArg
          -h --help               Display help information

      EXAMPLES
          myscript --help         Show this message

      """

  describe 'with command', ->

    it 'should not print alias if not defined', ->
      parameters
        name: 'myscript'
        description: 'Some description for myscript'
        commands: [
          name: 'status'
          description: 'Description for the status command'
          options: [
            name: 'cluster_names', type: 'string'
            description: 'Ensure alias is not displayed'
          ]
        ]
      .help()
      .should.eql """

      NAME
          myscript - Some description for myscript

      SYNOPSIS
          myscript <command>

      OPTIONS
          -h --help               Display help information

      COMMANDS
          status                  Description for the status command
          help                    Display help information about myscript

      EXAMPLES
          myscript --help         Show this message
          myscript help           Show this message

      """
