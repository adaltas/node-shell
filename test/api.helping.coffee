
parameters = require '../src'

describe 'api.helping', ->

    it 'with help command only', ->
      # With argv
      parameters
        commands: 'start': {}
      .helping ['help']
      .should.eql []
      # With params
      parameters
        commands: 'start': {}
      .helping
        command: ['help']
      .should.eql []

    it 'with help command followed by commands', ->
      # With argv
      parameters
        commands: 'start': commands: 'server': {}
      .helping ['help', 'start']
      .should.eql ['start']
      # With params
      parameters
        commands: 'start': commands: 'server': {}
      .helping
        command: 'help'
        name: 'start'
      .should.eql ['start']

    it 'with help options at root', ->
      # With argv
      parameters {}
      .helping ['--help']
      .should.eql []
      # With params
      parameters {}
      .helping
        help: true
      .should.eql []

    it 'with help options in the middle of subcommand', ->
      # With argv
      parameters
        commands: 'start': commands: 'server': {}
      .helping ['start', '--help', 'server']
      .should.eql ['start']
      # With params
      parameters
        commands: 'start': commands: 'server': {}
      .helping
        command: 'start'
        help: true
      .should.eql ['start']

    it 'with help options at the end of subcommand', ->
      # With argv
      parameters
        commands: 'start': commands: 'server': {}
      .helping ['start', 'server', '--help']
      .should.eql ['start', 'server']
      # With params
      parameters
        commands: 'start': commands: 'server': {}
      .helping
        command: ['start', 'server']
        help: true
      .should.eql ['start', 'server']
