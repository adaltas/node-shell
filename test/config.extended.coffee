
parameters = require '../src'

describe 'config.extended', ->
  
  describe 'validation', ->

    it 'must be a boolean', ->
      # Command with no option
      params = parameters extended: true
      params = parameters extended: false
      (->
        params = parameters extended: 'sth'
      ).should.throw 'Invalid Configuration: extended must be a boolean, got "sth"'
      (->
        params = parameters extended: {}
      ).should.throw 'Invalid Configuration: extended must be a boolean, got {}'

    it 'cannot be declared inside a command', ->
      (->
        params = parameters commands:
          mycmd:
            extended: true
      ).should.throw 'Invalid Command: extended cannot be declared inside a command'
      
  describe 'main', ->
    
    it 'application get leftover', ->
      params = parameters
        extended: true
        main:
          name: 'leftover'
      params.parse(['my --command']).should.eql [
        leftover: 'my --command'
      ]
      params.parse([]).should.eql [{}]
      params.stringify [
        leftover: 'my --command'
      ]
      .should.eql ['my --command']
      params.stringify([{}]).should.eql []
        
    it 'application with configured commands get leftover', ->
      params = parameters
        extended: true
        main:
          name: 'leftover'
        commands:
          subcommand: {}
      params.parse(['my --command']).should.eql [
        command: "help" # TODO, SHALL BE REMOVED
        leftover: 'my --command'
      ]
      params.stringify [
        leftover: 'my --command'
      ]
      .should.eql ['my --command']
  
