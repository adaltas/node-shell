
shell = require '../src'

describe 'configure.route', ->
  
  describe 'validation', ->
    
    it 'accept function', ->
      shell
        handler: (->)
      shell
        commands: 'server':
          handler: (->)
          
    it 'accept string', ->
      # In application
      shell
        handler: 'path/to/module'
      shell
        commands: 'server':
          handler: 'path/to/module'
    
    it 'throw error if not valid in application', ->
      (->
        shell
          handler: {}
      ).should.throw 'Invalid Route Configuration: accept string or function in application, got {}'

    it 'throw error if not valid in command', ->
      (->
        shell
          commands: 'server':
            handler: {}
      ).should.throw 'Invalid Route Configuration: accept string or function in command "server", got {}'
      
