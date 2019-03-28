
parameters = require '../src'

describe 'config.flatten', ->
  
  describe 'validation', ->

    it 'must be a boolean', ->
      # Command with no option
      params = parameters flatten: true
      params = parameters flatten: false
      (->
        params = parameters flatten: 'sth'
      ).should.throw 'Invalid Configuration: flatten must be a boolean, got "sth"'
      (->
        params = parameters flatten: {}
      ).should.throw 'Invalid Configuration: flatten must be a boolean, got {}'

    it 'cannot be declared inside a command', ->
      (->
        params = parameters commands:
          mycmd:
            flatten: true
      ).should.throw 'Invalid Command: flatten cannot be declared inside a command'
  
