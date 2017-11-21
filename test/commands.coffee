
parameters = require '../src'

describe 'commands', ->

  it 'accept no main and no option', ->
    params = parameters
      commands: [name: 'start']
    params.parse(['start']).should.eql
      command: 'start'
    params.stringify
      command: 'start'
    .should.eql ['start']

  it 'command is of type object', ->
    params = parameters
      commands: 'start': {}
    params.parse(['start']).should.eql
      command: 'start'
    params.stringify
      command: 'start'
    .should.eql ['start']

  it 'options is of type array', ->
    params = parameters commands: [
      name: 'start'
      options: [
        name: 'myparam'
      ]
    ]
    params.parse(['start', '--myparam', 'my value']).should.eql
      command: 'start'
      myparam: 'my value'
    params.stringify
      command: 'start'
      myparam: 'my value'
    .should.eql ['start', '--myparam', 'my value']

  it 'options is of type object', ->
    params = parameters
      commands:
        'start':
          options:
            myparam: {}
    params.parse(['start', '--myparam', 'my value']).should.eql
      command: 'start'
      myparam: 'my value'
    params.stringify
      command: 'start'
      myparam: 'my value'
    .should.eql ['start', '--myparam', 'my value']

  it 'throw error if command is undefined', ->
    params = parameters commands: [name: 'myaction']
    (->
      params.parse ['hum', '-s', 'my', '--command']
    ).should.throw 'Invalid Command: "hum"'
    (->
      params.stringify 
        command: 'hum'
        myparam: true
    ).should.throw 'Invalid Command: "hum"'

  it 'customize command name', ->
    params = parameters
      command: 'mycommand'
      commands: [name: 'start']
    params.parse(['start']).should.eql
      mycommand: 'start'
    params.stringify
      mycommand: 'start'
    .should.eql ['start']

  it 'mix with general options', ->
    params = parameters
      options: [
        name: 'gopt'
      ]
      commands: [
        name: 'start'
        options: [
          name: 'aopt'
        ]
      ]
    params.parse(['--gopt', 'toto', 'start', '--aopt', 'lulu']).should.eql
      gopt: 'toto'
      command: 'start'
      aopt: 'lulu'
    params.stringify
      gopt: 'toto'
      command: 'start'
      aopt: 'lulu'
    .should.eql ['--gopt', 'toto', 'start', '--aopt', 'lulu']

  describe 'nested', ->

    it 'with the same command name', ->
      params = parameters
        options: [
          name: 'opt_root'
        ]
        commands: [
          name: 'parent'
          options: [
            name: 'opt_parent'
          ]
          commands: [
            name: 'child'
            options: [
              name: 'opt_child'
            ]
          ]
        ]
      params.parse(['--opt_root', 'val 0', 'parent', '--opt_parent', 'val 1', 'child', '--opt_child', 'val 2']).should.eql
        command: ['parent', 'child']
        opt_root: 'val 0'
        opt_parent: 'val 1'
        opt_child: 'val 2'
      params.stringify
        command: ['parent', 'child']
        opt_root: 'val 0'
        opt_parent: 'val 1'
        opt_child: 'val 2'
      .should.eql ['--opt_root', 'val 0', 'parent', '--opt_parent', 'val 1', 'child', '--opt_child', 'val 2']

    it 'with different command name', ->
      params = parameters
        options: [
          name: 'opt_root'
        ]
        commands: [
          name: 'parent'
          options: [
            name: 'opt_parent'
          ]
          command: 'subcommand'
          commands: [
            name: 'child'
            options: [
              name: 'opt_child'
            ]
          ]
        ]
      params.parse(['--opt_root', 'val 0', 'parent', '--opt_parent', 'val 1', 'child', '--opt_child', 'val 2']).should.eql
        command: 'parent'
        subcommand: 'child'
        opt_root: 'val 0'
        opt_parent: 'val 1'
        opt_child: 'val 2'
      params.stringify
        command: 'parent'
        subcommand: 'child'
        opt_root: 'val 0'
        opt_parent: 'val 1'
        opt_child: 'val 2'
      .should.eql ['--opt_root', 'val 0', 'parent', '--opt_parent', 'val 1', 'child', '--opt_child', 'val 2']
