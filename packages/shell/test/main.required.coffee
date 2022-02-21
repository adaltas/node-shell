
import {shell} from '../lib/index.js'

describe 'main.required', ->

  it 'optional by default', ->
    app = shell
      commands: 'my_command':
        main:
          name: 'my_argument'
    app.parse [
      'my_command'
    ]
    .should.eql
      command: ['my_command']
      my_argument: []
    app.compile
      command: ['my_command']
    .should.eql ['my_command']

  it 'honors required true if value is provided', ->
    app = shell
      commands: 'my_command':
        main:
          name: 'my_argument'
          required: true
    app.parse [
      'my_command', 'my --value'
    ]
    .should.eql
      command: ['my_command']
      my_argument: ['my --value']
    app.compile
      command: ['my_command']
      my_argument: ['my --value']
    .should.eql ['my_command', 'my --value']

  it 'honors required true if no value provided', ->
    app = shell
      commands: 'my_command':
        main:
          name: 'my_argument'
          required: true
    (->
      app.parse ['my_command']
    ).should.throw 'Required Main Argument: no suitable arguments for "my_argument"'
    (->
      app.compile
        command: ['my_command']
    ).should.throw 'Required Main Parameter: no suitable arguments for "my_argument"'

  describe 'function', ->

    it 'receive config and command', ->
      app = shell
        commands: 'my_command':
          main:
            name: 'my_argument'
            required: ({config, command}) ->
              config.name.should.eql 'my_command'
              config.command.should.eql ['my_command']
              command.should.eql 'my_command'
              false
      app.parse ['my_command']

    it 'return `true`', ->
      app = shell
        commands: 'my_command':
          main:
            name: 'my_argument'
            required: -> true
      # Invalid, no argument is provided
      (->
        app.parse ['my_command']
      ).should.throw 'Required Main Argument: no suitable arguments for "my_argument"'
      (->
        app.compile
          command: ['my_command']
      ).should.throw 'Required Main Parameter: no suitable arguments for "my_argument"'
