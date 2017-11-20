
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
      name: 'myapp'
      description: 'No description yet'
      shortcuts: {}
      strict: false
        
  it 'empty with command', ->
    parameters(commands: 'my_cmd': {}).config.should.eql
      command: 'command'
      commands:
        'my_cmd':
          name: 'my_cmd'
          description: 'No description yet for the my_cmd command'
          options: {}
          strict: false
          shortcuts: {}
        'help':
          name: 'help',
          description: 'Display help information about myapp'
          main:
            name: 'name'
            description: 'Help about a specific command'
          strict: false
          options: {}
          shortcuts: {}
      name: 'myapp'
      description: 'No description yet'
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
          description: 'No description yet for the start command'
          options:
            'myparam':
              name: 'myparam'
              type: 'string'
          strict: false,
          shortcuts: {}
        'help':
          name: 'help',
          description: 'Display help information about myapp'
          main:
            name: 'name'
            description: 'Help about a specific command'
          strict: false
          shortcuts: {}
          options: {}
      name: 'myapp'
      description: 'No description yet'
      options: {}
      shortcuts: {}
      strict: false
