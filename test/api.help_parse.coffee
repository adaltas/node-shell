
parameters = require '../src'

describe 'help parse', ->

  it 'handle an empty command as help', ->
    params = parameters commands: [name: 'help']
    params.parse([]).should.eql
      command: 'help'

  it 'handle an empty command as even if help is not defined', ->
    params = parameters commands: [name: 'fake']
    params.parse([]).should.eql
      command: 'help'

  it 'global options without a command', ->
    params = parameters commands: [name: 'fake']
    params.parse(['--param', 'value']).should.eql
      param: 'value'
      command: 'help'

  it 'handle help command', ->
    params = parameters commands: [name: 'help']
    params.parse(['help']).should.eql
      command: 'help'
    params.stringify
      command: 'help'
    .should.eql ['help']

  it 'handle help command with a command', ->
    params = parameters commands: [name: 'toto']
    params.parse(['help', 'start']).should.eql
      command: 'help'
      name: 'start'
    params.stringify
      command: 'help'
      name: 'start'
    .should.eql ['help', 'start']
