
import {shell} from '../../lib/index.js'
  
describe 'options.type', ->

  describe 'string', ->

    it 'is default type', ->
      app = shell
        commands: 'start':
          options: 'my_option':
            shortcut: 'w'
      app.parse(['start', '--my_option', 'my value']).should.eql
        command: ['start']
        my_option: 'my value'
      app.compile
        command: ['start']
        my_option: 'my value'
      .should.eql ['start', '--my_option', 'my value']

  describe 'boolean', ->

    it 'handle boolean option', ->
      app = shell
        commands: 'start':
          options: 'strict':
            shortcut: 's'
            type: 'boolean'
      app.parse(['start', '-s']).should.eql
        command: ['start']
        strict: true
      app.compile
        command: ['start']
        strict: true
      .should.eql ['start', '--strict']

    it 'bypass a boolean option set to null', ->
      app = shell
        options: 'detached':
          shortcut: 'd'
          type: 'boolean'
      app.compile
        detached: null
      .should.eql []

  describe 'integer', ->

    it 'handle shortcut', ->
      app = shell
        commands: 'start':
          options: 'integer':
            shortcut: 'i'
            type: 'integer'
      app.parse(['start', '-i', '5']).should.eql
        command: ['start']
        integer: 5
      app.compile
        command: ['start']
        integer: 5
      .should.eql ['start', '--integer', '5']

    it 'validate', ->
      app = shell
        commands: 'start':
          options:
            'an_int':
              type: 'integer'
      ( ->
        app.parse(['start', '--an_int', 'invalid'])
      ).should.throw 'Invalid Option: value of "an_int" is not an integer, got "invalid"'

  describe 'array', ->

    it 'handle shortcut', ->
      app = shell
        commands: 'start':
          options: 'array':
            shortcut: 'a'
            type: 'array'
      app.parse(['start', '-a', '3,2,1'])
      .should.eql
        command: ['start']
        array: ['3','2','1']
      app.compile
        command: ['start']
        array: ['3','2','1']
      .should.eql ['start', '--array', '3,2,1']

    it 'handle multiple properties', ->
      app = shell
        commands: 'start':
          options: 'array':
            shortcut: 'a'
            type: 'array'
      app.parse(['start', '-a', '3', '-a', '2', '-a', '1']).should.eql
        command: ['start']
        array: ['3','2','1']
      app.compile
        command: ['start']
        array: ['3','2','1']
      .should.eql ['start', '--array', '3,2,1']

    it 'handle empty values', ->
      app = shell
        commands: 'start':
          options: 'my_array':
            type: 'array'
      app.parse(['start', '--my_array', '', '--my_array', '2', '--my_array', '']).should.eql
        command: ['start']
        my_array: ['','2','']
      app.compile
        command: ['start']
        array: ['','2','']
      .should.eql ['start', '--array', ',2,']
