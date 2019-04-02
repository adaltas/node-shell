
parameters = require '../src'

describe 'api.help_parse', ->

  it 'handle an empty command as help', ->
    app = parameters commands: [name: 'help']
    app.parse([]).should.eql
      command: ['help']

  it 'handle an empty command as even if help is not defined', ->
    app = parameters commands: [name: 'fake']
    app.parse([]).should.eql
      command: ['help']

  it 'global options without a command', ->
    app = parameters commands: [name: 'fake']
    app.parse(['--param', 'value']).should.eql
      param: 'value'
      command: ['help']

  it.skip 'global options without a sub command', ->
    # Note, this test illustrate a bug where parse reference @config instead of config:
    # if Object.keys(@config.commands).length and not params[@config.command]
    #   params[@config.command] = 'help'
    # The assertion is what we expect in current version but in a future version,
    # it shall only work if a new `help` config is declared
    app = parameters commands: [name: 'level1', commands: [name: 'level2']]
    app.parse(['--param', 'value', 'level1']).should.eql
      param: 'value'
      command: ['value1', 'help']

  it 'handle help command', ->
    app = parameters commands: [name: 'help']
    app.parse(['help']).should.eql
      command: ['help']
    app.stringify
      command: ['help']
    .should.eql ['help']

  it 'handle help command with a command', ->
    app = parameters commands: [name: 'toto']
    app.parse(['help', 'start']).should.eql
      command: ['help']
      name: 'start'
    app.stringify
      command: ['help']
      name: 'start'
    .should.eql ['help', 'start']
