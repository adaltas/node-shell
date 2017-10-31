
should = require 'should'
parameters = require '../src'

describe 'help shortcut', ->

  describe 'without command', ->

    it 'should print without shortcut', ->
      params = parameters
        name: 'myscript'
        description: 'Some description for myscript'
        options: [
          name: 'myarg'
          description: 'MyArg'
        ]
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

    it 'should not print alias if not defined', ->
      params = parameters
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
      params.help().should.eql """
      NAME
          myscript - Some description for myscript
      SYNOPSIS
          myscript command [options...]
          where command is one of
            status            Description for the status command
            help              Display help information about myscript
      DESCRIPTION
          status              Description for the status command
            --cluster_names     Ensure alias is not displayed
          help                Display help information about myscript
            name                Help about a specific command
      EXAMPLES
          myscript help       Show this message

      """
      params.help().should.eql params.help 'help'
