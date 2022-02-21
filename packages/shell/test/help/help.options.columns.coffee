
import {shell} from '../../lib/index.js'

describe 'help/help.options.columns', ->

  it 'first columns must exceed 10', ->
    (->
      shell().help([], columns: 8)
    ).should.throw [
      'Invalid Help Column Option:'
      'must exceed a size of 10 columns,'
      'got 8'
    ].join ' '

  it 'an integer map to the first columns', ->
    shell
      main: 'a_main'
      options:
        'an_option':
          type: 'boolean'
    .help([], columns: 20).should.eql """

    NAME
      myapp - No description yet

    SYNOPSIS
      myapp [myapp options] {a_main}

    OPTIONS
         a_main         No description yet for the a_main option.
         --an_option    No description yet for the an_option option.
      -h --help         Display help information
    
    EXAMPLES
      myapp --help      Show this message

    """
