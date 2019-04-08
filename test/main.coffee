
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

    it 'workout any main arguments', ->
      app = parameters
        main:
          name: 'leftover'
      app.parse([]).should.eql {}
      app.stringify({}).should.eql []

    it 'preserve space in main arguments', ->
      app = parameters
        main:
          name: 'leftover'
      app.parse [
        'my value'
      ]
      .should.eql
        leftover: ['my value']
      app.stringify 
        leftover: ['my value']
      .should.eql ['my value']

    it 'handle multiple main arguments', ->
      app = parameters
        main:
          name: 'leftover'
      app.parse [
        'my', 'value'
      ]
      .should.eql
        leftover: ['my', 'value']
      app.stringify 
        leftover: ['my', 'value']
      .should.eql ['my', 'value']
  
  describe 'with command', ->

    it 'accept an optional main and no option', ->
      app = parameters commands: [
        name: 'start'
        main:
          name: 'leftover'
      ]
      app.parse [
        'start', 'my', 'value true'
      ]
      .should.eql
        command: ['start']
        leftover: ['my', 'value true']
      app.stringify
        command: ['start']
        leftover: ['my', 'value true']
      .should.eql ['start', 'my', 'value true']

    it 'may follow command without any option', ->
      app = parameters commands: [
        name: 'mycommand'
        main: 
          name: 'leftover'
          required: true
      ]
      app.parse [
        'mycommand', 'my value'
      ]
      .should.eql
        command: ['mycommand']
        leftover: ['my value']
      app.stringify 
        command: ['mycommand']
        leftover: ['my value']
      .should.eql ['mycommand', 'my value']
