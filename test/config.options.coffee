
parameters = require '../src'

describe 'config.options', ->
  
  describe 'validation', ->
    
    it 'detect collision between application and command options', ->
      # OK in extended mode
      app = parameters
        extended: true
        options:
          config: {}
        commands:
          start:
            options: config: {}
      # Not OK in flatten mode
      (->
        app = parameters
          options:
            config: {}
          commands:
            start:
              options: config: {}
      ).should.throw 'Invalid Option Configuration: option "config" in command "start" collide with the one in application, change its name or use the extended property'
        
    it 'detect collision between 2 command options', ->
      app = parameters
        extended: true
        commands:
          server:
            options:
              config: {}
            commands:
              start:
                options: config: {}
      # Not OK in flatten mode
      (->
        app = parameters
          commands:
            server:
              options:
                config: {}
              commands:
                start:
                  options: config: {}
      ).should.throw 'Invalid Option Configuration: option "config" in command "server start" collide with the one in "server", change its name or use the extended property'
