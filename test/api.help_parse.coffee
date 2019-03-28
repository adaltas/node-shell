
parameters = require '../src'

describe 'api.help_parse', ->

  it 'handle an empty command as help', ->
    params = parameters commands: [name: 'help']
    params.parse([]).should.eql
      command: ['help']

  it 'handle an empty command as even if help is not defined', ->
    params = parameters commands: [name: 'fake']
    params.parse([]).should.eql
      command: ['help']

  it 'global options without a command', ->
    params = parameters commands: [name: 'fake']
    params.parse(['--param', 'value']).should.eql
      param: 'value'
      command: ['help']

  it.skip 'global options without a sub command', ->
    # Note, this test illustrate a bug where parse reference @config instead of config:
    # if Object.keys(@config.commands).length and not params[@config.command]
    #   params[@config.command] = 'help'
    # The assertion is what we expect in current version but in a future version,
    # it shall only work if a new `help` config is declared
    params = parameters commands: [name: 'level1', commands: [name: 'level2']]
    params.parse(['--param', 'value', 'level1']).should.eql
      param: 'value'
      command: ['value1', 'help']

  it 'handle help command', ->
    params = parameters commands: [name: 'help']
    params.parse(['help']).should.eql
      command: ['help']
    params.stringify
      command: ['help']
    .should.eql ['help']

  it 'handle help command with a command', ->
    params = parameters commands: [name: 'toto']
    params.parse(['help', 'start']).should.eql
      command: ['help']
      name: 'start'
    params.stringify
      command: ['help']
      name: 'start'
    .should.eql ['help', 'start']
