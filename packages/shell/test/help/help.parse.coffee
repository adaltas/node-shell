
shell = require '../../lib'

describe 'help/help.parse', ->
  
  describe 'dont interfere with command', ->
    # NOTE: the tests in this group used to inject an help command
    # when parsing arguments which doesnt hit a sub command
    # TODO: in the future, either remove entirely those tests
    # or introduce an help config option such as 'print_help_unless_leaf_command'

    it 'handle an empty command as help', ->
      shell
        commands: 'help': {}
      .parse []
      .should.eql
        command: [] # Old behaviour was `['help']`

    it 'handle an empty command as even if help is not defined', ->
      shell
        commands: 'fake': {}
      .parse []
      .should.eql
        command: [] # Old behaviour was `['help']`

    it 'global options without a command', ->
      shell
        commands: 'fake': {}
      .parse ['--param', 'value']
      .should.eql
        param: 'value'
        command: [] # Old behaviour was `['help']`

  it 'handle help command', ->
    app = shell
      commands: 'help': {}
    app.parse ['help']
    .should.eql
      command: ['help']
      name: []
    app.compile
      command: ['help']
    .should.eql ['help']

  it 'handle help command with a command', ->
    app = shell
      commands: 'toto': {}
    app.parse ['help', 'start']
    .should.eql
      command: ['help']
      name: ['start']
    app.compile
      command: ['help']
      name: ['start']
    .should.eql ['help', 'start']
