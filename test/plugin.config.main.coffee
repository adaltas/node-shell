
parameters = require '../src'

describe 'plugin.config.main', ->
  
  describe 'get', ->

    it 'for application', ->
      parameters
        options: 'config': {}
        main: 'leftover'
      .confx().main.get().should.eql
        name: 'leftover'

    it 'for a command', ->
      parameters
        commands: 'app': commands: 'server':
          main: 'leftover'
      .confx().commands(['app', 'server']).main.get()
      .should.eql
        name: 'leftover'
          
  describe 'set', ->

    it 'for application', ->
      parameters {}
      .confx().commands([]).main
      .set('leftover')
      .get().should.eql
        name: 'leftover'
  
