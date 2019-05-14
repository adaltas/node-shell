
parameters = require '../src'

describe 'main', ->
  
  describe 'invalid', ->

    it 'command extra arguments without main', ->
      # Command with no option
      (->
        parameters
          commands:
            'mycommand': {}
        .parse ['mycommand', 'mymain']
      ).should.throw 'Invalid Argument: fail to interpret all arguments "mymain"'
      # Command with one option
      (->
        parameters
          commands:
            'mycommand': options: 'arg': {}
        .parse ['mycommand', '--arg', 'myarg', 'mymain']
      ).should.throw 'Invalid Argument: fail to interpret all arguments "mymain"'
  
  describe 'without command', ->

    it 'workout any main arguments', ->
      app = parameters
        main:
          name: 'leftover'
      app.parse([]).should.eql {}
      app.compile({}).should.eql []

    it 'preserve space in main arguments', ->
      app = parameters
        main:
          name: 'leftover'
      app.parse [
        'my value'
      ]
      .should.eql
        leftover: ['my value']
      app.compile
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
      app.compile
        leftover: ['my', 'value']
      .should.eql ['my', 'value']
  
  describe 'with command', ->

    it 'accept an optional main and no option', ->
      app = parameters
        commands: 'start':
          main:
            name: 'leftover'
      app.parse [
        'start', 'my', 'value true'
      ]
      .should.eql
        command: ['start']
        leftover: ['my', 'value true']
      app.compile
        command: ['start']
        leftover: ['my', 'value true']
      .should.eql ['start', 'my', 'value true']

    it 'may follow command without any option', ->
      app = parameters
        commands: 'mycommand':
          main:
            name: 'leftover'
            required: true
      app.parse [
        'mycommand', 'my value'
      ]
      .should.eql
        command: ['mycommand']
        leftover: ['my value']
      app.compile
        command: ['mycommand']
        leftover: ['my value']
      .should.eql ['mycommand', 'my value']
