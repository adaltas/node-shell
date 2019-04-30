
parameters = require '../src'

describe 'plugin.config.main.api', ->
  
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
      .confx(['app', 'server']).main.get()
      .should.eql
        name: 'leftover'
          
  describe 'set', ->

    it 'for application', ->
      parameters {}
      .confx().main
      .set('leftover')
      .get().should.eql
        name: 'leftover'
