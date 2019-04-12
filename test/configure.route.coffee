
parameters = require '../src'

describe 'configure.route', ->
  
  describe 'validation', ->
    
    it 'accept function', ->
      # In application
      parameters
        route: (->)
      parameters
        commands: [
          name: 'server'
          route: (->)
        ]
          
    it 'accept string', ->
      # In application
      parameters
        route: 'path/to/module'
      parameters
        commands: [
          name: 'server'
          route: 'path/to/module'
        ]
    
    it 'throw error if not valid', ->
      # In application
      (->
        parameters
          route: {}
      ).should.throw 'Invalid Route Configuration: accept string or function in application, got {}'
      # In command
      (->
        parameters
          commands: [
            name: 'server'
            route: {}
          ]
      ).should.throw 'Invalid Route Configuration: accept string or function in command "server", got {}'
      
