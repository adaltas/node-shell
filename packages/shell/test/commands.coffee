
shell = require '../lib'

describe 'commands', ->

  it 'no property is required', ->
    app = shell
      commands: 'start': {}
    app.parse ['start']
    .should.eql
      command: ['start']
    app.compile
      command: ['start']
    .should.eql ['start']

  it 'options is of type object', ->
    app = shell
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
    app.compile
      command: ['start']
      myparam: 'my value'
    .should.eql ['start', '--myparam', 'my value']

  it 'customize command name', ->
    app = shell
      command: 'mycommand'
      commands: 'start': {}
    app.parse ['start']
    .should.eql
      mycommand: ['start']
    app.compile
      mycommand: ['start']
    .should.eql ['start']

  it 'mix with general options', ->
    app = shell
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
    app.compile
      gopt: 'toto'
      command: ['start']
      aopt: 'lulu'
    .should.eql ['--gopt', 'toto', 'start', '--aopt', 'lulu']

  describe 'nested', ->

    it 'with the same command name', ->
      app = shell
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
      app.compile
        command: ['parent', 'child']
        opt_root: 'val 0'
        opt_parent: 'val 1'
        opt_child: 'val 2'
      .should.eql ['--opt_root', 'val 0', 'parent', '--opt_parent', 'val 1', 'child', '--opt_child', 'val 2']
