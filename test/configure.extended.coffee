
parameters = require '../src'

describe 'configure.extended', ->
  
  describe 'validation', ->

    it 'must be a boolean', ->
      # Command with no option
      app = parameters extended: true
      app = parameters extended: false
      (->
        app = parameters extended: 'sth'
      ).should.throw 'Invalid Configuration: extended must be a boolean, got "sth"'
      (->
        app = parameters extended: {}
      ).should.throw 'Invalid Configuration: extended must be a boolean, got {}'

    it 'cannot be declared inside a command', ->
      (->
        app = parameters commands:
          mycmd:
            extended: true
      ).should.throw 'Invalid Command: extended cannot be declared inside a command'
      
  describe 'main', ->
    
    it 'application get leftover', ->
      app = parameters
        extended: true
        main:
          name: 'leftover'
      app.parse(['my value']).should.eql [
        leftover: ['my value']
      ]
      app.parse([]).should.eql [{}]
      app.stringify [
        leftover: ['my value']
      ]
      .should.eql ['my value']
      app.stringify([{}]).should.eql []
        
    it 'application with configured commands get leftover', ->
      app = parameters
        extended: true
        main:
          name: 'leftover'
        commands:
          subcommand: {}
      app.parse(['my --command']).should.eql [
        command: "help" # TODO, SHALL BE REMOVED
        leftover: ['my --command']
      ]
      app.stringify [
        leftover: ['my --command']
      ]
      .should.eql ['my --command']
  
