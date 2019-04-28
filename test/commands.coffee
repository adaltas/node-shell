
parameters = require '../src'

describe 'commands', ->

  it 'no property is required', ->
    app = parameters
      commands: 'start': {}
    app.parse ['start']
    .should.eql
      command: ['start']
    app.stringify
      command: ['start']
    .should.eql ['start']

  it 'options is of type object', ->
    app = parameters
      commands:
        'start':
          options:
            myparam: {}
    app.parse [
      'start', '--myparam', 'my value'
    ]
    .should.eql
      command: ['start']
      myparam: 'my value'
    app.stringify
      command: ['start']
      myparam: 'my value'
    .should.eql ['start', '--myparam', 'my value']

  it 'customize command name', ->
    app = parameters
      command: 'mycommand'
      commands: 'start': {}
    app.parse ['start']
    .should.eql
      mycommand: ['start']
    app.stringify
      mycommand: ['start']
    .should.eql ['start']

  it 'mix with general options', ->
    app = parameters
      options: 'gopt': {}
      commands: 'start':
        options: 'aopt': {}
    app.parse [
      '--gopt', 'toto', 'start', '--aopt', 'lulu'
    ]
    .should.eql
      gopt: 'toto'
      command: ['start']
      aopt: 'lulu'
    app.stringify
      gopt: 'toto'
      command: ['start']
      aopt: 'lulu'
    .should.eql ['--gopt', 'toto', 'start', '--aopt', 'lulu']

  describe 'nested', ->

    it 'with the same command name', ->
      app = parameters
        options: 'opt_root': {}
        commands: 'parent':
          options: 'opt_parent': {}
          commands: 'child':
            options: 'opt_child': {}
      app.parse [
        '--opt_root', 'val 0', 'parent', '--opt_parent', 'val 1', 'child', '--opt_child', 'val 2'
      ]
      .should.eql
        command: ['parent', 'child']
        opt_root: 'val 0'
        opt_parent: 'val 1'
        opt_child: 'val 2'
      app.stringify
        command: ['parent', 'child']
        opt_root: 'val 0'
        opt_parent: 'val 1'
        opt_child: 'val 2'
      .should.eql ['--opt_root', 'val 0', 'parent', '--opt_parent', 'val 1', 'child', '--opt_child', 'val 2']
