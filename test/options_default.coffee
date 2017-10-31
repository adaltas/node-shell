
parameters = require '../src'

describe 'options default', ->
  
  describe 'without commands', ->
    
    it 'set value if not defined', ->
      params = parameters
        options: [
          name: 'my_argument', default: 'default value'
        ]
      params.parse([]).should.eql
        my_argument: 'default value'
      params.stringify {}
      .should.eql ['--my_argument', 'default value']

  describe 'with commands', ->
    
    it 'set value if not defined', ->
      params = parameters commands: [
        name: 'my_command'
        options: [
          name: 'my_argument', default: 'default value'
        ]
      ]
      params.parse(['my_command']).should.eql
        command: 'my_command'
        my_argument: 'default value'
      params.stringify command: 'my_command'
      .should.eql ['my_command', '--my_argument', 'default value']
          
    it 'preserve global option', ->
      params = parameters 
        options: [
          name: 'global_argument', default: 'global value'
        ]
        commands: [
          name: 'my_command'
          options: [
            name: 'command_argument', default: 'command value'
          ]
        ]
      params.parse(['my_command']).should.eql
        command: 'my_command'
        global_argument: 'global value'
        command_argument: 'command value'
      params.stringify command: 'my_command'
      .should.eql ['--global_argument', 'global value', 'my_command', '--command_argument', 'command value']
