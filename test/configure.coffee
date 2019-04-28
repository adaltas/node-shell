
path = require 'path'
parameters = require '../src'

describe 'configure', ->

  describe 'normalisation', ->
    
    it 'is immutable', ->
      config = {}
      parameters config
      config.should.eql {}

    it 'empty without command', ->
      parameters({})
      .confx().get().should.eql
        name: 'myapp'
        description: 'No description yet'
        extended: false
        router:
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
            cascade: true
            help: true
            description: 'Display help information'
            shortcut: 'h'
            type: 'boolean'
        commands: {}
          
    it 'command command', ->
      parameters
        commands:
          'my_cmd': {}
      .confx().get().should.eql
        name: 'myapp'
        description: 'No description yet'
        extended: false
        router:
          end: false
          writer: 'stderr'
          route: path.resolve __dirname, '../src/routes/help'
        root: true
        options:
          'help':
            cascade: true
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
                cascade: true
                description: 'Display help information'
                help: true
                name: 'help'
                shortcut: 'h'
                transient: true
                type: 'boolean'
            commands: {}
            strict: false
            shortcuts:
              'h': 'help'
          'help':
            name: 'help'
            help: true
            description: 'Display help information'
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
        commands: 'parent_cmd':
          commands: 'child_cmd': {}
      .confx().get().should.eql
        name: 'myapp'
        description: 'No description yet'
        extended: false
        router:
          end: false
          writer: 'stderr'
          route: path.resolve __dirname, '../src/routes/help'
        root: true
        options:
          'help':
            cascade: true
            description: 'Display help information'
            help: true
            name: 'help'
            shortcut: 'h'
            type: 'boolean'
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
                cascade: true
                description: 'Display help information'
                help: true
                name: 'help'
                shortcut: 'h'
                transient: true
                type: 'boolean'
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
                    cascade: true
                    description: 'Display help information'
                    help: true
                    name: 'help'
                    shortcut: 'h'
                    transient: true
                    type: 'boolean'
                commands: {}
                strict: false
                shortcuts:
                  'h': 'help'
          'help':
            name: 'help'
            help: true
            description: 'Display help information'
            command: ['help']
            main:
              name: 'name'
              description: 'Help about a specific command'
            route: path.resolve __dirname, '../src/routes/help'
            strict: false
            options: {}
            commands: {}
            shortcuts: {}
