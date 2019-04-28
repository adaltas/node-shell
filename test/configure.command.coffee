
parameters = require '../src'

describe 'configure.command', ->
  
  describe 'validation', ->
    
    it 'only at application level', ->
      (->
        parameters
          commands: 'server':
            command: 'invalid'
            commands: 'start': {}
      ).should.throw 'Invalid Command Configuration: command property can only be declared at the application level, got command "invalid"'
      
