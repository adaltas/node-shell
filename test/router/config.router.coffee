
path = require 'path'
parameters = require '../../src'
{ Writable } = require('stream')

describe 'router.config.router', ->
  
  describe 'router', ->
    
    it "accept string (eg stderr)", ->
      parameters({})
      .config.router.should.eql
        writer: 'stderr'
        route: path.resolve __dirname, '../../src/routes/help'
          
    it "stream.Writable", ->
      parameters
        router: writer: new Writable()
      .config.router.should.eql
        writer: new Writable()
        route: path.resolve __dirname, '../../src/routes/help'

  describe 'options', ->
  
    it 'auto generate the help options in application', ->
      parameters({})
      .confx().get().options.should.eql
        'help':
          cascade: true
          description: 'Display help information'
          help: true
          name: 'help'
          type: 'boolean'
          shortcut: 'h'
      parameters({})
      .confx().get().shortcuts.should.eql
        'h': 'help'
          
    it 'auto generate the help options in command with sub-command', ->
      parameters
        commands:
          'server':
            commands:
              'start': {}
      .confx(['server']).get().options.should.eql
        'help':
          cascade: true
          description: 'Display help information'
          help: true
          name: 'help'
          shortcut: 'h'
          transient: true
          type: 'boolean'
  
  describe 'commands', ->
  
    it 'overwrite command description', ->
      parameters
        commands:
          'start':
            options: 'myopt': {}
          'help':
            description: 'Overwrite description'
      .confx().get().commands.help.should.eql
        name: 'help'
        help: true
        description: 'Overwrite description'
        command: ['help']
        main:
          name: 'name'
          description: 'Help about a specific command'
        route: path.resolve __dirname, '../../src/routes/help'
        strict: false
        shortcuts: {}
        options: {}
        commands: {}

    it 'does not conflict with default description', ->
      parameters
        commands:
          'start': {}
          'help': {}
      .config.commands.help.description.should.eql 'Display help information'
