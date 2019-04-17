
parameters = require '../src'

describe 'plugin.config.main', ->
  
  describe 'get', ->

    it 'for application', ->
      parameters
        options: 'config': {}
        main: 'leftover'
      .configure().main.get().should.eql
        name: 'leftover'

    it 'for a command', ->
      parameters
        commands: 'app': commands: 'server':
          main: 'leftover'
      .configure().commands(['app', 'server']).main.get()
      .should.eql
        name: 'leftover'
          
  describe 'set', ->

    it 'for application', ->
      parameters {}
      .configure().main
      .set('leftover')
      .get().should.eql
        name: 'leftover'
  
