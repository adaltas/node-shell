
parameters = require '../src'

describe 'plugin.config.options', ->
  
  describe 'list', ->

    it 'for application', ->
      parameters
        options: 'config': {}
        commands: 'server': commands: 'start': {}
      .configure().options.list()
      .should.eql ['config', 'help']

    it 'for a command', ->
      parameters
        options: 'config': {}
        commands: 'app': commands: 'server': options:
          'host': {}
          'port': {}
      .configure().commands(['app', 'server']).options.list()
      .should.eql ['host', 'port', 'help']
    
  describe 'get', ->

    it 'all configuration', ->
      parameters
        options: 'config': {}
        commands: 'server': commands: 'start': {}
      .configure().get().root.should.be.true()
    
    it 'an option (2 styles)', ->
      parameters
        options: 'config': {}
        commands: 'server': commands: 'start': {}
      .configure().options('config').get()
      .name.should.eql 'config'
      parameters
        options: 'config': {}
        commands: 'server': commands: 'start': {}
      .configure().options.get('config')
      .name.should.eql 'config'
    
    it 'selected properties from option', ->
      parameters
        options: 'config': {}
        commands: 'server': commands: 'start': {}
      .configure().options('config')
      .set('description', 'hello')
      .set('required', true)
      .get(['description', 'required'])
      .should.eql
        description: 'hello'
        required: true
          
  describe 'set', ->

    it 'an option in a command', ->
      parameters
        options: 'config': {}
        commands: 'server': commands: 'start': {}
      .configure().options('config')
      .set('description', 'hello')
      .set('required', true)
      .get().name.should.eql 'config'
  
