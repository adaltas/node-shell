
shell = require '../../src'

describe 'options.default', ->
  
  describe 'without commands', ->
    
    it 'set value if not defined', ->
      app = shell
        options: 'my_argument':
          default: 'default value'
      app.parse []
      .should.eql
        my_argument: 'default value'
      app.compile {}
      .should.eql ['--my_argument', 'default value']

  describe 'with commands', ->
    
    it 'set value if not defined', ->
      app = shell
        commands: 'my_command':
          options: 'my_argument':
            default: 'default value'
      app.parse [
        'my_command'
      ]
      .should.eql
        command: ['my_command']
        my_argument: 'default value'
      app.compile command: ['my_command']
      .should.eql ['my_command', '--my_argument', 'default value']
          
    it 'preserve global option', ->
      app = shell
        commands: 'my_command':
          options: 'command_argument':
            default: 'command value'
        options: 'global_argument':
          default: 'global value'
      app.parse(['my_command']).should.eql
        command: ['my_command']
        global_argument: 'global value'
        command_argument: 'command value'
      app.compile command: ['my_command']
      .should.eql ['--global_argument', 'global value', 'my_command', '--command_argument', 'command value']
