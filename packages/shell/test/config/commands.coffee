
shell = require '../../lib'

describe 'config.commands', ->
  
  describe 'get', ->

    it 'application configuration', ->
      shell
        options: 'config': {}
        commands: 'server': commands: 'start': {}
      .confx().get().root.should.be.true()
    
    it 'get a child command', ->
      shell
        options: 'config': {}
        commands: 'server': commands: 'start': {}
      .confx(['server']).get()
      .command.should.eql ['server']
    
    it 'get a deep child command', ->
      shell
        options: 'config': {}
        commands: 'server': commands: 'start': {}
      .confx(['server', 'start']).get()
      .command.should.eql ['server', 'start']
  
  describe 'set', ->
      
    it 'exepect 1 or 2 arguments', ->
      (->
        shell
          options: 'config': {}
        .confx().set()
      ).should.throw 'Invalid Commands Set Arguments: expect 1 or 2 arguments, got 0'
      
    it 'an object', ->
      config = shell
        options: 'config': {}
        commands: 'server': commands: 'start': {}
      .confx(['server', 'stop'])
      .set(
        route: 'path/to/route'
        options: 'force': {}
      )
      .get()
      config.route.should.eql 'path/to/route'
      config.options.force.should.eql
        name: 'force'
        type: 'string'
            
    it 'key values', ->
      config = shell
        options: 'config': {}
        commands: 'server': commands: 'start': {}
      .confx(['server', 'stop'])
      .set('route', 'path/to/route')
      .set('options', 'force': {})
      .get()
      config.route.should.eql 'path/to/route'
      config.options.force.should.eql
        name: 'force'
        type: 'string'
      
    it 'call the hook', ->
      shell {}
      .register
        'configure_set': ({config}, handler) ->
          config.test = 'was here'
          handler
      .confx('start').set
        route: 'path/to/route'
      .get().test.should.eql 'was here'
