
should = require 'should'
parameters = require '..'

describe 'encode', ->

  describe 'api', ->

    it 'should prefix with node path and executed script', ->
      params = parameters actions: start:
        options: [
          name: 'myparam'
        ]
      [process.execPath, './bin/myscript', 'start', '--myparam', 'my value'].should.eql params.encode './bin/myscript',
        action: 'start'
        myparam: 'my value'

  describe 'with action', ->

    it 'accept no main and no option', ->
      params = parameters actions: start: {}
      ['start'].should.eql params.encode
        action: 'start'

    it 'accept no main and a string option', ->
      params = parameters actions: start:
        options: [
          name: 'myparam'
        ]
      ['start', '--myparam', 'my value'].should.eql params.encode
        action: 'start'
        myparam: 'my value'

    it 'accept an optional main and no option', ->
      params = parameters actions: start: 
        main:
          name: 'command'
      ['start', 'my --command'].should.eql params.encode
        action: 'start'
        command: 'my --command'
      ['start'].should.eql params.encode
        action: 'start'

    it 'throw error if action is undefined', ->
      params = parameters actions: {}
      (->
        params.encode 
          action: 'hum'
          myparam: true
      ).should.throw "Invalid action 'hum'"

  describe 'option', ->

    it 'handle string option', ->
      params = parameters  actions: start:
        options: [
          name: 'watch'
          shortcut: 'w'
        ]
      ['start', '--watch', __dirname].should.eql params.encode 
        action: 'start'
        watch: __dirname

    it 'handle boolean option', ->
      params = parameters actions: start:
        options: [
          name: 'strict'
          shortcut: 's'
          type: 'boolean'
        ]
      ['start', '--strict'].should.eql params.encode 
        action: 'start'
        strict: true

    it 'handle multiple options', ->
      params = parameters actions: start:
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
      ['start', '--watch', __dirname, '--strict', 'my --command'].should.eql params.encode 
        action: 'start'
        watch: __dirname
        strict: true
        command: 'my --command'

    it 'throw error if option is undefined', ->
      params = parameters actions: myaction: {}
      (->
        params.encode 
          action: 'myaction'
          myoption: true
      ).should.throw "Invalid option 'myoption'"

    it 'should bypass a boolean option set to null', ->
      params = parameters actions: start:
        options: [
          name: 'detached'
          shortcut: 'd'
          type: 'boolean'
        ]
      ['start'].should.eql params.encode 
        action: 'start'
        detached: null

  describe 'main', ->

    it 'may follow action without any option', ->
      params = parameters actions: myaction: 
        main: 
          name: 'command'
          required: true
      ['myaction', 'mycommand'].should.eql params.encode 
        action: 'myaction'
        command: 'mycommand'

    it 'may be optional', ->
      params = parameters actions: myaction: 
        main: 
          name: 'mycommand'
      ['myaction'].should.eql params.encode 
        action: 'myaction'

    it 'may be required', ->
      params = parameters actions: myaction: 
        main: 
          name: 'mycommand'
          required: true
      ['myaction', 'my --command'].should.eql params.encode
        action: 'myaction'
        mycommand: 'my --command'
      (->
        params.encode
          action: 'myaction'
      ).should.throw 'Required main argument "mycommand"'
