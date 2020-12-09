
shell = require '../../src'

describe 'config.extended', ->
  
  describe 'validation', ->

    it 'must be a boolean', ->
      # Command with no option
      shell extended: true
      shell extended: false
      (->
        shell extended: 'sth'
      ).should.throw 'Invalid Configuration: extended must be a boolean, got "sth"'
      (->
        shell extended: {}
      ).should.throw 'Invalid Configuration: extended must be a boolean, got {}'

    it 'cannot be declared inside a command', ->
      (->
        shell commands:
          mycmd:
            extended: true
      ).should.throw 'Invalid Command Configuration: extended property cannot be declared inside a command'
      
  describe 'main', ->
    
    it 'application get leftover', ->
      app = shell
        extended: true
        main:
          name: 'leftover'
      app.parse(['my value']).should.eql [
        leftover: ['my value']
      ]
      app.parse([]).should.eql [{
        leftover: []
      }]
      app.compile [
        leftover: ['my value']
      ]
      .should.eql ['my value']
      app.compile([{}]).should.eql []
    
    it 'application with configured commands get leftover', ->
      app = shell
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
  
