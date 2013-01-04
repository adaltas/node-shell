
should = require 'should'
parameters = require '..'

describe 'decode', ->

  describe 'help', ->

    it 'handle an empty action as help', ->
      params = parameters help: {}
      expect = action: 'help'
      # as a string
      expect.should.eql params.decode 'node myscript'
      # as an array
      expect.should.eql params.decode ['node', 'myscript']

    it 'handle help command', ->
      params = parameters help: {}
      expect = action: 'help'
      # as a string
      expect.should.eql params.decode 'node myscript help'
      # as an array
      expect.should.eql params.decode ['node', 'myscript', 'help']

    it 'handle help command with an action', ->
      params = parameters help: {}
      expect = 
        action: 'help'
        command: 'start'
      # as a string
      expect.should.eql params.decode 'node myscript help start'
      # as an array
      expect.should.eql params.decode ['node', 'myscript', 'help', 'start']

  describe 'with action', ->

    it 'accept no main and no option', ->
      params = parameters start: {}
      expect = action: 'start'
      expect.should.eql params.decode ['node', 'myscript', 'start']

    it 'accept no main and a string option', ->
      params = parameters start:
        options: [
          name: 'myparam'
        ]
      expect = 
        action: 'start'
        myparam: 'my value'
      expect.should.eql params.decode ['node', 'myscript', 'start', '--myparam', 'my value']

    it 'accept an optional main and no option', ->
      params = parameters start: 
        main:
          name: 'command'
      expect = 
        action: 'start'
        command: 'my --command'
      expect.should.eql params.decode ['node', 'myscript', 'start', 'my --command']
      expect = 
        action: 'start'
        command: null
      expect.should.eql params.decode ['node', 'myscript', 'start']
  
    it 'throw error if action is undefined', ->
      params = parameters()
      (->
        params.decode ['node', 'myscript', 'hum', '-s', 'my', '--command']
      ).should.throw "Invalid action 'hum'"
    
  describe 'option', ->

    it 'handle string option', ->
      params = parameters start:
        options: [
          name: 'watch'
          shortcut: 'w'
        ]
      expect = 
        action: 'start'
        watch: __dirname
      # as a string
      expect.should.eql params.decode "node myscript start --watch #{__dirname}"
      # as an array
      expect.should.eql params.decode ['node', 'myscript', 'start', '--watch', __dirname]

    it 'handle boolean option', ->
      params = parameters start:
        options: [
          name: 'strict'
          shortcut: 's'
          type: 'boolean'
        ]
      expect = 
        action: 'start'
        strict: true
      # as a string
      expect.should.eql params.decode "node myscript start -s"
      # as an array
      expect.should.eql params.decode ['node', 'myscript', 'start', '-s']

    it 'handle multiple options', ->
      params = parameters start:
        main: 
          name: 'command'
          required: true
        options: [
          name: 'watch'
          shortcut: 'w'
        ,
          name: 'strict'
          shortcut: 's'
          type: 'boolean'
        ]
      expect = 
        action: 'start'
        watch: __dirname
        strict: true
        command: 'my --command'
      # as a string
      expect.should.eql params.decode "node myscript start --watch #{__dirname} -s my --command"
      # as an array
      expect.should.eql params.decode ['node', 'myscript', 'start', '--watch', __dirname, '-s', 'my', '--command']

    it 'throw error if decoding undefined option', ->
      params = parameters myaction: {}
      (->
        params.decode ['node', 'myscript', 'myaction', '--myoption', 'my', '--command']
      ).should.throw "Invalid option 'myoption'"

  describe 'main', ->

    it 'may follow action without any option', ->
      params = parameters myaction: 
        main: 
          name: 'command'
          required: true
      expect = 
        action: 'myaction'
        command: 'mycommand'
      expect.should.eql params.decode ['node', 'myscript', 'myaction', 'mycommand']

    it 'may be optional', ->
      params = parameters myaction: 
        main: 
          name: 'command'
      expect = 
        action: 'myaction'
        command: null
      expect.should.eql params.decode ['node', 'myscript', 'myaction']

    it 'may be required', ->
      params = parameters myaction: 
        main: 
          name: 'command'
          required: true
      expect = 
        action: 'myaction'
        command: 'my --command'
      expect.should.eql params.decode ['node', 'myscript', 'myaction', 'my --command']
      (->
        params.decode ['node', 'myscript', 'myaction']
      ).should.throw 'Required main argument "command"'

