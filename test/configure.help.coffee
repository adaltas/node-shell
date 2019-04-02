
parameters = require '../src'

describe 'configure.help', ->
  
  it 'auto generate the help options in application', ->
    parameters({})
    .config.options.should.eql
      'help':
        name: 'help'
        shortcut: 'h'
        description: 'Display help information'
        type: 'boolean'
        help: true
    parameters({})
    .config.shortcuts.should.eql
      'h': 'help'
          
  it 'auto generate the help options in command with sub-command', ->
    parameters
      commands:
        'server':
          commands:
            'start': {}
    .config.commands.server.options.should.eql
      'help':
        name: 'help'
        shortcut: 'h'
        description: 'Display help information'
        type: 'boolean'
        help: true
  
  it 'overwrite command description', ->
    parameters
      commands:
        'start':
          options: [
            name: 'myparam'
          ]
        'help':
          description: 'Overwrite description'
    .config.commands.help.should.eql
      name: 'help'
      help: true
      description: 'Overwrite description'
      command: ['help']
      main:
        name: 'name'
        description: 'Help about a specific command'
      strict: false
      shortcuts: {}
      options: {}
      commands: {}

  it 'does not conflict with default description', ->
    parameters
      commands:
        'start': {}
        'help': {}
    .config.commands.help.description.should.eql 'Display help information about myapp'
