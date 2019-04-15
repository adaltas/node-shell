
parameters = require '../src'

describe 'config.get', ->
  
  describe 'get', ->
  
    it.skip 'property is function without arguments', ->
      console.log (
        parameters({})
        .configure().show()
      )
  
  describe 'options list', ->

    it 'for application', ->
      parameters
        options: 'config': {}
        commands: 'server': commands: 'start': {}
      .configure().options.list().should.eql ['config', 'help']

    it 'for a command', ->
      parameters
        options: 'config': {}
        commands: 'app': commands: 'server': options:
          'host': {}
          'port': {}
      .configure().commands(['app', 'server']).options.list()
      .should.eql ['host', 'port', 'help']
    
  describe 'options get', ->

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
          
  describe 'options set', ->

    it 'an option in a command', ->
      parameters
        options: 'config': {}
        commands: 'server': commands: 'start': {}
      .configure().options('config')
      .set('description', 'hello')
      .set('required', true)
      .get().name.should.eql 'config'
  
  describe 'commands get', ->
        
    it 'get a child command', ->
      parameters
        options: 'config': {}
        commands: 'server': commands: 'start': {}
      .configure().commands('server').get()
      .command.should.eql ['server']
      
    it 'get a deep child command', ->
      parameters
        options: 'config': {}
        commands: 'server': commands: 'start': {}
      .configure().commands(['server', 'start']).get()
      .command.should.eql ['server', 'start']
    
    it 'traverse commands', ->
      parameters
        options: 'config': {}
        commands: 'server': commands: 'start': {}
      .configure().commands('server').commands('start').get()
      .command.should.eql ['server', 'start']
  
  describe 'commands set', ->
      
    it 'exepect 1 or 2 arguments', ->
      (->
        parameters
          options: 'config': {}
          commands: 'server': commands: 'start': {}
        .configure().commands('server').commands('stop')
        .set()
      ).should.throw 'Invalid Commands Set Arguments: expect 1 or 2 arguments, got 0'
      
    it 'an object', ->
      parameters
        options: 'config': {}
        commands: 'server': commands: 'start': {}
      .configure().commands('server').commands('stop')
      .set(
        options: 'force': {}
      )
      .show().should.eql
        name: 'stop'
        options: 'force': {}
            
    it 'key values', ->
      parameters
        options: 'config': {}
        commands: 'server': commands: 'start': {}
      .configure().commands('server').commands('stop')
      .set('route', 'path/to/route')
      .set('options', 'force': {})
      .show().should.eql
        name: 'stop'
        route: 'path/to/route'
        options: 'force': {}
