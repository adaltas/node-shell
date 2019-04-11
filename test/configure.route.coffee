
parameters = require '../src'

describe 'configure.route', ->
  
  describe 'validation', ->
    
    it 'accept function', ->
      # In application
      app = parameters
        route: (->)
      app = parameters
        commands: [
          name: 'server'
          route: (->)
        ]
          
    it 'accept string', ->
      # In application
      app = parameters
        route: 'path/to/module'
      app = parameters
        commands: [
          name: 'server'
          route: 'path/to/module'
        ]
    
    it 'throw error if not valid', ->
      # In application
      (->
        app = parameters
          route: {}
      ).should.throw 'Invalid Route Configuration: accept string or function in application, got {}'
      # In command
      (->
        app = parameters
          commands: [
            name: 'server'
            route: {}
          ]
      ).should.throw 'Invalid Route Configuration: accept string or function in command "server", got {}'
      
