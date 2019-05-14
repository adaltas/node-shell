
parameters = require '../../src'

describe 'config.extended', ->
  
  describe 'validation', ->

    it 'must be a boolean', ->
      # Command with no option
      parameters extended: true
      parameters extended: false
      (->
        parameters extended: 'sth'
      ).should.throw 'Invalid Configuration: extended must be a boolean, got "sth"'
      (->
        parameters extended: {}
      ).should.throw 'Invalid Configuration: extended must be a boolean, got {}'

    it 'cannot be declared inside a command', ->
      (->
        parameters commands:
          mycmd:
            extended: true
      ).should.throw 'Invalid Command Configuration: extended property cannot be declared inside a command'
      
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
      app.compile [
        leftover: ['my value']
      ]
      .should.eql ['my value']
      app.compile([{}]).should.eql []
    
    it 'application with configured commands get leftover', ->
      app = parameters
        extended: true
        main:
          name: 'leftover'
        commands:
          subcommand: {}
      app.parse(['my --command']).should.eql [
        leftover: ['my --command']
      ]
      app.compile [
        leftover: ['my --command']
      ]
      .should.eql ['my --command']
  
