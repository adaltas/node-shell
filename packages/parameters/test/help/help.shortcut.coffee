
shell = require '../../src'

describe 'help/help.shortcut', ->

  describe 'without command', ->

    it 'should print without shortcut', ->
      shell
        name: 'myscript'
        description: 'Some description for myscript'
        options: 'myarg':
          description: 'MyArg'
      .help()
      .should.eql """
      
      NAME
        myscript - Some description for myscript

      SYNOPSIS
        myscript [myscript options]

      OPTIONS
        -h --help                 Display help information
           --myarg                MyArg

      EXAMPLES
        myscript --help           Show this message

      """

  describe 'with command', ->

    it 'should not print alias if not defined', ->
      shell
        name: 'myscript'
        description: 'Some description for myscript'
        commands: 'status':
          description: 'Description for the status command'
          options: 'cluster_names':
            type: 'string'
            description: 'Ensure alias is not displayed'
      .help()
      .should.eql """

      NAME
        myscript - Some description for myscript

      SYNOPSIS
        myscript <command>

      OPTIONS
        -h --help                 Display help information

      COMMANDS
        status                    Description for the status command
        help                      Display help information

      EXAMPLES
        myscript --help           Show this message
        myscript help             Show this message

      """
