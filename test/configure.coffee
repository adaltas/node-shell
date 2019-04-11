
path = require 'path'
parameters = require '../src'

describe 'configure', ->

  describe 'normalisation', ->

    it 'empty without command', ->
      parameters({}).config.should.eql
        name: 'myapp'
        description: 'No description yet'
        extended: false
        help:
          end: false
          writer: 'stderr'
          route: path.resolve __dirname, '../src/routes/help'
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
          
    it 'command command', ->
      parameters
        commands:
          'my_cmd': {}
      .config.should.eql
        name: 'myapp'
        description: 'No description yet'
        extended: false
        help:
          end: false
          writer: 'stderr'
          route: path.resolve __dirname, '../src/routes/help'
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
            command: ['my_cmd']
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
            command: ['help']
            main:
              name: 'name'
              description: 'Help about a specific command'
            route: path.resolve __dirname, '../src/routes/help'
            strict: false
            options: {}
            commands: {}
            shortcuts: {}
          
    it 'nested empty commands', ->
      parameters
        commands:
          'parent_cmd':
            commands:
              'child_cmd': {}
      .config.should.eql
        name: 'myapp'
        description: 'No description yet'
        extended: false
        help:
          end: false
          writer: 'stderr'
          route: path.resolve __dirname, '../src/routes/help'
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
            command: ['parent_cmd']
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
                command: ['parent_cmd', 'child_cmd']
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
            command: ['help']
            main:
              name: 'name'
              description: 'Help about a specific command'
            route: path.resolve __dirname, '../src/routes/help'
            strict: false
            options: {}
            commands: {}
            shortcuts: {}
      
    it 'define command and options as an array', ->
      array = parameters
        commands: [
          name: 'start'
          options: [
            name: 'myparam'
          ]
        ]
      object = parameters(
        commands:
          'start':
            options:
              'myparam': {}
      )
      array.config.should.eql object.config
