
parameters = require '../src'

describe 'api config', ->
  
  it 'empty without command', ->
    parameters({}).config.should.eql
      command: 'command'
      commands: {}
      options:
        'help':
          name: 'help'
          help: true
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
          options:
            'help': 
              name: 'help'
              shortcut: 'h'
              description: 'Display help information'
              type: 'boolean'
              help: true
          command: 'command'
          commands: {}
          strict: false
          shortcuts: {}
        'help':
          name: 'help'
          help: true
          description: 'Display help information about myapp'
          main:
            name: 'name'
            description: 'Help about a specific command'
          strict: false
          options: {}
          command: 'command'
          commands: {}
          shortcuts: {}
      name: 'myapp'
      description: 'No description yet'
      options:
        'help': 
          name: 'help'
          shortcut: 'h'
          description: 'Display help information'
          type: 'boolean'
          help: true
      shortcuts: {}
      strict: false
        
  it 'empty with nested commands', ->
    parameters(commands: 'parent_cmd': commands: 'child_cmd': {}).config.should.eql
      command: 'command'
      commands:
        'parent_cmd':
          name: 'parent_cmd'
          description: 'No description yet for the parent_cmd command'
          options:
            'help': 
              name: 'help'
              shortcut: 'h'
              description: 'Display help information'
              type: 'boolean'
              help: true
          strict: false
          shortcuts: {}
          command: 'command'
          commands:
            'child_cmd':
              name: 'child_cmd'
              description: 'No description yet for the child_cmd command'
              options:
                'help': 
                  name: 'help'
                  shortcut: 'h'
                  description: 'Display help information'
                  type: 'boolean'
                  help: true
              command: 'command'
              commands: {}
              strict: false
              shortcuts: {}
        'help':
          name: 'help'
          help: true
          description: 'Display help information about myapp'
          main:
            name: 'name'
            description: 'Help about a specific command'
          strict: false
          options: {}
          command: 'command'
          commands: {}
          shortcuts: {}
      name: 'myapp'
      description: 'No description yet'
      options:
        'help': 
          name: 'help'
          shortcut: 'h'
          description: 'Display help information'
          type: 'boolean'
          help: true
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
            'help': 
              name: 'help'
              shortcut: 'h'
              description: 'Display help information'
              type: 'boolean'
              help: true
          command: 'command'
          commands: {}
          strict: false,
          shortcuts: {}
        'help':
          name: 'help'
          help: true
          description: 'Display help information about myapp'
          main:
            name: 'name'
            description: 'Help about a specific command'
          strict: false
          shortcuts: {}
          options: {}
          command: 'command'
          commands: {}
      name: 'myapp'
      description: 'No description yet'
      options:
        'help': 
          name: 'help'
          shortcut: 'h'
          description: 'Display help information'
          type: 'boolean'
          help: true
      shortcuts: {}
      strict: false
