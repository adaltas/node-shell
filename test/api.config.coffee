
parameters = require '../src'

describe 'api.config', ->
  
  it 'empty without command', ->
    parameters({}).config.should.eql
      name: 'myapp'
      description: 'No description yet'
      flatten: true
      root: true
      strict: false
      shortcuts:
        'h': 'help'
      options:
        'help':
          name: 'help'
          help: true
          description: 'Display help information'
          shortcut: 'h'
          type: 'boolean'
      commands: {}
        
  it 'empty with command', ->
    parameters(commands: 'my_cmd': {}).config.should.eql
      name: 'myapp'
      description: 'No description yet'
      flatten: true
      root: true
      options:
        'help': 
          name: 'help'
          shortcut: 'h'
          description: 'Display help information'
          type: 'boolean'
          help: true
      shortcuts:
        'h': 'help'
      strict: false
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
          commands: {}
          strict: false
          shortcuts:
            'h': 'help'
        'help':
          name: 'help'
          help: true
          description: 'Display help information about myapp'
          main:
            name: 'name'
            description: 'Help about a specific command'
          strict: false
          options: {}
          commands: {}
          shortcuts: {}
        
  it 'empty with nested commands', ->
    parameters(commands: 'parent_cmd': commands: 'child_cmd': {}).config.should.eql
      name: 'myapp'
      description: 'No description yet'
      flatten: true
      root: true
      options:
        'help': 
          name: 'help'
          shortcut: 'h'
          description: 'Display help information'
          type: 'boolean'
          help: true
      shortcuts:
        'h': 'help'
      strict: false
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
          shortcuts:
            'h': 'help'
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
              commands: {}
              strict: false
              shortcuts:
                'h': 'help'
        'help':
          name: 'help'
          help: true
          description: 'Display help information about myapp'
          main:
            name: 'name'
            description: 'Help about a specific command'
          strict: false
          options: {}
          commands: {}
          shortcuts: {}
    
  it 'define command and options as an array', ->
    parameters
      commands: [
        name: 'start'
        options: [
          name: 'myparam'
        ]
      ]
    .config.should.eql
      name: 'myapp'
      description: 'No description yet'
      flatten: true
      root: true
      options:
        'help': 
          name: 'help'
          shortcut: 'h'
          description: 'Display help information'
          type: 'boolean'
          help: true
      shortcuts:
        'h': 'help'
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
          commands: {}
          strict: false
          shortcuts:
            'h': 'help'
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
          commands: {}
      strict: false
  
  describe 'overwrite help', ->

    it 'works', ->
      parameters
        commands:
          'start':
            options: [
              name: 'myparam'
            ]
          'help':
            description: 'Overwrite description'
      .config.should.eql
        name: 'myapp'
        description: 'No description yet'
        flatten: true
        root: true
        options:
          'help': 
            name: 'help'
            shortcut: 'h'
            description: 'Display help information'
            type: 'boolean'
            help: true
        shortcuts:
          'h': 'help'
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
            commands: {}
            strict: false
            shortcuts:
              'h': 'help'
          'help':
            name: 'help'
            help: true
            description: 'Overwrite description'
            main:
              name: 'name'
              description: 'Help about a specific command'
            strict: false
            shortcuts: {}
            options: {}
            commands: {}
        strict: false

    it 'does not conflict with default description', ->
      parameters
        commands:
          'start': {}
          'help': {}
      .config.commands.help.description.should.eql 'Display help information about myapp'
