
parameters = require '../src'

describe 'options.default', ->
  
  describe 'without commands', ->
    
    it 'set value if not defined', ->
      app = parameters
        options: [
          name: 'my_argument', default: 'default value'
        ]
      app.parse([]).should.eql
        my_argument: 'default value'
      app.stringify {}
      .should.eql ['--my_argument', 'default value']

  describe 'with commands', ->
    
    it 'set value if not defined', ->
      app = parameters commands: [
        name: 'my_command'
        options: [
          name: 'my_argument', default: 'default value'
        ]
      ]
      app.parse(['my_command']).should.eql
        command: ['my_command']
        my_argument: 'default value'
      app.stringify command: ['my_command']
      .should.eql ['my_command', '--my_argument', 'default value']
          
    it 'preserve global option', ->
      app = parameters 
        options: [
          name: 'global_argument', default: 'global value'
        ]
        commands: [
          name: 'my_command'
          options: [
            name: 'command_argument', default: 'command value'
          ]
        ]
      app.parse(['my_command']).should.eql
        command: ['my_command']
        global_argument: 'global value'
        command_argument: 'command value'
      app.stringify command: ['my_command']
      .should.eql ['--global_argument', 'global value', 'my_command', '--command_argument', 'command value']
