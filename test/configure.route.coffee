
parameters = require '../src'

describe 'configure.route', ->
  
  describe 'validation', ->
    
    it 'accept function', ->
      parameters
        handler: (->)
      parameters
        commands: 'server':
          handler: (->)
          
    it 'accept string', ->
      # In application
      parameters
        handler: 'path/to/module'
      parameters
        commands: 'server':
          handler: 'path/to/module'
    
    it 'throw error if not valid in application', ->
      (->
        parameters
          handler: {}
      ).should.throw 'Invalid Route Configuration: accept string or function in application, got {}'

    it 'throw error if not valid in command', ->
      (->
        parameters
          commands: 'server':
            handler: {}
      ).should.throw 'Invalid Route Configuration: accept string or function in command "server", got {}'
      
