
parameters = require '../src'

describe 'main', ->
  
  describe 'invalid', ->

    it 'command extra arguments without main', ->
      # Command with no option
      params = parameters commands: [name: 'mycommand']
      (->
        params.parse ['mycommand', 'mymain']
      ).should.throw "Fail to parse end of command \"mymain\""
      # Command with one option
      params = parameters commands: [name: 'mycommand', options: [name:'arg']]
      (->
        params.parse ['mycommand', '--arg', 'myarg', 'mymain']
      ).should.throw "Fail to parse end of command \"mymain\""
  
  describe 'without command', ->

    it 'work with no option', ->
      params = parameters
        main:
          name: 'leftover'
      params.parse(['my --command']).should.eql
        leftover: 'my --command'
      params.parse([]).should.eql {}
      params.stringify 
        leftover: 'my --command'
      .should.eql ['my --command']
      params.stringify({}).should.eql []
  
  describe 'with command', ->

    it 'accept an optional main and no option', ->
      params = parameters commands: [
        name: 'start'
        main:
          name: 'leftover'
      ]
      params.parse(['start', 'my --command']).should.eql
        command: ['start']
        leftover: 'my --command'
      params.stringify
        command: ['start']
        leftover: 'my --command'
      .should.eql ['start', 'my --command']

    it 'may follow command without any option', ->
      params = parameters commands: [
        name: 'mycommand'
        main: 
          name: 'leftover'
          required: true
      ]
      params.parse(['mycommand', 'my value']).should.eql
        command: ['mycommand']
        leftover: 'my value'
      params.stringify 
        command: ['mycommand']
        leftover: 'my value'
      .should.eql ['mycommand', 'my value']
