
parameters = require '../src'

describe 'main', ->
  
  describe 'invalid', ->

    it 'command extra arguments without main', ->
      # Command with no option
      app = parameters commands: [name: 'mycommand']
      (->
        app.parse ['mycommand', 'mymain']
      ).should.throw "Fail to parse end of command \"mymain\""
      # Command with one option
      app = parameters commands: [name: 'mycommand', options: [name:'arg']]
      (->
        app.parse ['mycommand', '--arg', 'myarg', 'mymain']
      ).should.throw "Fail to parse end of command \"mymain\""
  
  describe 'without command', ->

    it 'work with no option', ->
      app = parameters
        main:
          name: 'leftover'
      app.parse(['my --command']).should.eql
        leftover: 'my --command'
      app.parse([]).should.eql {}
      app.stringify 
        leftover: 'my --command'
      .should.eql ['my --command']
      app.stringify({}).should.eql []
  
  describe 'with command', ->

    it 'accept an optional main and no option', ->
      app = parameters commands: [
        name: 'start'
        main:
          name: 'leftover'
      ]
      app.parse(['start', 'my --command']).should.eql
        command: ['start']
        leftover: 'my --command'
      app.stringify
        command: ['start']
        leftover: 'my --command'
      .should.eql ['start', 'my --command']

    it 'may follow command without any option', ->
      app = parameters commands: [
        name: 'mycommand'
        main: 
          name: 'leftover'
          required: true
      ]
      app.parse(['mycommand', 'my value']).should.eql
        command: ['mycommand']
        leftover: 'my value'
      app.stringify 
        command: ['mycommand']
        leftover: 'my value'
      .should.eql ['mycommand', 'my value']
