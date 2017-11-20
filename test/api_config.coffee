
parameters = require '../src'

describe 'api config', ->
  
  it 'empty without command', ->
    parameters({}).config.should.eql
      command: 'command'
      commands: {}
      options:
        'help':
          name: 'help'
          description: 'Display help information'
          shortcut: 'h'
          type: 'boolean'
      shortcuts: {}
      strict: false
        
  it 'empty with command', ->
    parameters(commands: 'my_cmd': {}).config.should.eql
      command: 'command'
      commands:
        'my_cmd':
          name: 'my_cmd'
          options: {}
          strict: false
          shortcuts: {}
        'help':
          name: 'help',
          description: 'Display help information about undefined'
          main:
            name: 'name'
            description: 'Help about a specific command'
          strict: false
          options: {}
          shortcuts: {}
      options: {}
      shortcuts: {}
      strict: false
    
    
  it 'define command and options as an array', ->
    parameters
      commands: [
        name: 'start'
        options: [
          name: 'myparam'
        ]
      ]
    .config.should.eql
      command: 'command'
      commands:
        'start':
          name: 'start'
          options:
            'myparam':
              name: 'myparam'
              type: 'string'
          strict: false,
          shortcuts: {}
        'help':
          name: 'help',
          description: 'Display help information about undefined'
          main:
            name: 'name'
            description: 'Help about a specific command'
          strict: false
          shortcuts: {}
          options: {}
      options: {}
      shortcuts: {}
      strict: false
