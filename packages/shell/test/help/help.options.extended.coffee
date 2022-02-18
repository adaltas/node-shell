
shell = require '../../lib'

describe 'help/help.options.extended', ->

  it 'print command related information', ->
    shell
      commands:
        'start': {}
    .help([], extended: true).should.eql """

    NAME
      myapp - No description yet

    SYNOPSIS
      myapp <command>

    OPTIONS
      -h --help                 Display help information

    COMMANDS
      start                     No description yet for the start command
      help                      Display help information
    
    COMMAND "start"
      start                     No description yet for the start command
    
    COMMAND "help"
      help                      Display help information
      help {name}               Help about a specific command

    EXAMPLES
      myapp --help              Show this message
      myapp help                Show this message

    """

  it 'print sub command related information', ->
    shell
      commands:
        'server':
          commands:
            'start': {}
    .help(['server'], extended: true).should.eql """

    NAME
      myapp server - No description yet for the server command

    SYNOPSIS
      myapp server <command>

    OPTIONS for server
      -h --help                 Display help information

    OPTIONS for myapp
      -h --help                 Display help information

    COMMANDS
      start                     No description yet for the start command
    
    COMMAND "start"
      start                     No description yet for the start command

    EXAMPLES
      myapp server --help       Show this message

    """
