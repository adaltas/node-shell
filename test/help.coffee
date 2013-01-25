
should = require 'should'
parameters = require "../#{if process.env.PARAMETERS_COV then 'lib-cov' else 'src'}"

describe 'help', ->

  it 'handle an empty action as help', ->
    params = parameters actions: [name: 'help']
    params.parse([]).should.eql
      action: 'help'

  it 'handle an empty action as even if help is not defined', ->
    params = parameters actions: [name: 'fake']
    params.parse([]).should.eql
      action: 'help'

  it 'handle help command', ->
    params = parameters actions: [name: 'help']
    params.parse(['help']).should.eql
      action: 'help'
    params.stringify
      action: 'help'
    .should.eql ['help']

  it.only 'handle help command with an action', ->
    params = parameters actions: [name: 'toto']
    params.parse(['help', 'start']).should.eql
      action: 'help'
      command: 'start'
    params.stringify
      action: 'help'
      command: 'start'
    .should.eql ['help', 'start']

  describe 'without action', ->

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

  describe 'with action', ->

    it 'should print multiple actions with multiple options', ->
      params = parameters
        name: 'myscript'
        description: 'Some description for myscript'
        actions: [
          name: 'start'
          description: 'Description for the start action'
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
          description: 'Description for the stop action'
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
          myscript action [options...]
          where action is one of
            start             Description for the start action
            stop              Description for the stop action
            help              Display help information about myscript
      DESCRIPTION
          start               Description for the start action
            -s --string         String option in start
            -b --boolean        Boolean option in start
            -i --integer        Integer option in start
            command             Command in start
          stop                Description for the stop action
            -s --string         String option in stop
            -b --boolean        Boolean option in stop
            command             Command in stop
          help                Display help information about myscript
            command             Help about a specific action
      EXAMPLES
          myscript help       Show this message

      """
      params.help().should.eql params.help 'help'

    it 'describe an action', ->
      params = parameters
        name: 'myscript'
        description: 'Some description for myscript'
        actions:[
          name: 'start'
          description: 'Description for the start action'
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
          myscript start - Description for the start action
      SYNOPSIS
          myscript start [options...] [command]
      DESCRIPTION
          start               Description for the start action
            -s --string         String option in start
            command             Command in start

      """

    it 'display main without braket if required', ->
      params = parameters
        name: 'myscript'
        description: 'Some description for myscript'
        actions: [
          name: 'start'
          description: 'Description for the start action'
          main: 
            name: 'command'
            description: 'Command in start'
            required: true
        ]
      params.help('start').should.eql """
      NAME
          myscript start - Description for the start action
      SYNOPSIS
          myscript start command
      DESCRIPTION
          start               Description for the start action
            command             Command in start

      """

    it 'display options without brakets at least one required', ->
      params = parameters
        name: 'myscript'
        description: 'Some description for myscript'
        actions: [
          name: 'start'
          description: 'Description for the start action'
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
          myscript start - Description for the start action
      SYNOPSIS
          myscript start options...
      DESCRIPTION
          start               Description for the start action
            -o --optional       Optional option
            -r --required       Required option

      """
