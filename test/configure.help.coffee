
path = require 'path'
parameters = require '../src'
{ Writable } = require('stream')

describe 'configure.help', ->
  
  describe 'help', ->
    
    it "accept string (eg stderr)", ->
      parameters({})
      .config.help.should.eql
        end: false
        writer: 'stderr'
        route: path.resolve __dirname, '../src/routes/help'
          
    it "stream.Writable", ->
      parameters
        help: writer: new Writable()
      .config.help.should.eql
        end: false
        writer: new Writable()
        route: path.resolve __dirname, '../src/routes/help'

  describe 'options', ->
  
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
  
  describe 'commands', ->
  
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
        route: path.resolve __dirname, '../src/routes/help'
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
