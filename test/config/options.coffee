
parameters = require '../../src'

describe 'config.options', ->
  
  describe 'validation', ->
    
    it 'enforce types at application level', ->
      (->
        parameters
          options:
            key: type: 'invalid'
      ).should.throw [
        'Invalid Option Configuration:'
        'supported options types are ["string","boolean","integer","array"],'
        'got "invalid" for option "key"'
      ].join ' '
    
    it 'enforce types at command level', ->
      (->
        parameters
          commands: 'server': commands: 'start': options:
            key: type: 'invalid'
      ).should.throw [
        'Invalid Option Configuration:'
        'supported options types are ["string","boolean","integer","array"],'
        'got "invalid" for option "key" in command "server start"'
      ].join ' '
    
    it 'enforce one_of', ->
      (->
        parameters
          options:
            key: one_of: true
      ).should.throw 'Invalid Option Configuration: option property "one_of" must be a string or an array, got true'
  
  describe 'collision', ->
    
    it 'dont detect collision in extended mode', ->
      parameters
        extended: true
        options:
          collide: {}
        commands:
          start:
            options: collide: {}
    
    it 'dont detect collision on a same command level', ->
      parameters
        # options: collide: {}
        commands:
          server:
            commands:
              start:
                options: collide: {}
              stop:
                options: collide: {}

    it 'detect collision between application and command options', ->
      (->
        parameters
          options:
            collide: {}
          commands:
            start:
              options: collide: {}
      ).should.throw 'Invalid Option Configuration: option "collide" in command "start" collide with the one in application, change its name or use the extended property'
    
    it 'detect collision between 2 command options', ->
      parameters
        extended: true
        commands:
          server:
            options:
              collide: {}
            commands:
              start:
                options: v: {}
      # Not OK in flatten mode
      (->
        parameters
          commands:
            server:
              options:
                collide: {}
              commands:
                start:
                  options: collide: {}
      ).should.throw 'Invalid Option Configuration: option "collide" in command "server start" collide with the one in "server", change its name or use the extended property'
