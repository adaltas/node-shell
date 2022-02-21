
import {shell} from '../../lib/index.js'

describe 'options.required', ->
  
  describe 'optional', ->

    it 'may be optional with string', ->
      app = shell
        commands: 'mycommand':
          options: 'my_argument': {}
      app.parse ['mycommand']
      .should.eql
        command: ['mycommand']
      app.compile
        command: ['mycommand']
      .should.eql ['mycommand']

    it 'may be optional with array', ->
      app = shell
        commands: 'mycommand':
          options: 'my_argument':
            type: 'array'
      app.parse ['mycommand']
      .should.eql
        command: ['mycommand']
      app.compile
        command: ['mycommand']
      .should.eql ['mycommand']

  describe 'enforce', ->

    it 'honors required true if value is provided', ->
      app = shell
        commands: 'mycommand':
          options: 'my_argument':
            required: true
      app.parse ['mycommand', '--my_argument', 'my --value']
      .should.eql
        command: ['mycommand']
        my_argument: 'my --value'
      app.compile
        command: ['mycommand']
        my_argument: 'my --value'
      .should.eql ['mycommand', '--my_argument', 'my --value']

    it 'honors required true if no value provided', ->
      app = shell
        commands: 'mycommand':
          options: 'my_argument':
            required: true
      (->
        app.parse ['mycommand']
      ).should.throw 'Required Option: the "my_argument" option must be provided'
      (->
        app.compile
          command: ['mycommand']
      ).should.throw 'Required Option: the "my_argument" option must be provided'
  
  describe 'function', ->
  
      it 'receive config and command', ->
        app = shell
          commands: 'my_command':
            options:
              'my_option':
                type: 'boolean'
                required: ({config, command}) ->
                  config.name.should.eql 'my_command'
                  config.command.should.eql ['my_command']
                  command.should.eql 'my_command'
                  false
        app.parse ['my_command', '--my_option']

      it 'return `true`', ->
        app = shell
          commands: 'my_command':
            options:
              'my_option':
                type: 'boolean'
                required: -> true
        # Invalid, no argument is provided
        (->
          app.parse ['my_command']
        ).should.throw 'Required Option: the "my_option" option must be provided'
        (->
          app.compile
            command: ['my_command']
        ).should.throw 'Required Option: the "my_option" option must be provided'

  describe 'compatible with help', ->
    
    it 'without command', ->
      shell()
      .parse(['--help']).should.eql
        help: true
    
    it 'with command', ->
      shell
        commands: 'parent':
          commands: 'child':
            options:  'my_argument':
              required: true
      .parse(['parent', 'child', '--help']).should.eql
        command: ['parent', 'child']
        help: true
    
    it 'stop command nested discovery', ->
      shell
        commands: 'parent':
          commands: 'child':
            options:  'my_argument':
              required: true
      .parse(['parent', '--help', 'child']).should.eql
        command: ['parent']
        help: true
      
