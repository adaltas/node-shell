
import {shell} from '../../lib/index.js'

describe 'help/help.options.one_column', ->

  it 'is `true`', ->
    shell
      main: 'a_main'
      options:
        'debug':
          type: 'boolean'
    .help([], one_column: true).should.eql """

    NAME
      myapp
      No description yet

    SYNOPSIS
      myapp [myapp options] {a_main}

    OPTIONS
      a_main
      No description yet for the a_main option.
      --debug
      No description yet for the debug option.
      -h
      --help
      Display help information
    
    EXAMPLES
      myapp --help
      Show this message

    """
