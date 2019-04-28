
parameters = require '../src'

describe 'options.required', ->
  
  describe 'optional', ->

    it 'may be optional with string', ->
      app = parameters
        commands: 'mycommand':
          options: 'my_argument': {}
      app.parse ['mycommand']
      .should.eql
        command: ['mycommand']
      app.stringify
        command: ['mycommand']
      .should.eql ['mycommand']

    it 'may be optional with array', ->
      app = parameters
        commands: 'mycommand':
          options: 'my_argument':
            type: 'array'
      app.parse ['mycommand']
      .should.eql
        command: ['mycommand']
      app.stringify
        command: ['mycommand']
      .should.eql ['mycommand']

  describe 'enforce', ->

    it 'honors required true if value is provided', ->
      app = parameters
        commands: 'mycommand':
          options: 'my_argument':
            required: true
      app.parse ['mycommand', '--my_argument', 'my --value']
      .should.eql
        command: ['mycommand']
        my_argument: 'my --value'
      app.stringify
        command: ['mycommand']
        my_argument: 'my --value'
      .should.eql ['mycommand', '--my_argument', 'my --value']

    it 'honors required true if no value provided', ->
      app = parameters
        commands: 'mycommand':
          options: 'my_argument':
            required: true
      (->
        app.parse ['mycommand']
      ).should.throw 'Required Option Argument: the "my_argument" option must be provided'
      (->
        app.stringify
          command: ['mycommand']
      ).should.throw 'Required Option Parameter: the "my_argument" option must be provided'
  
  describe 'compatible with help', ->
    
    it 'without command', ->
      parameters()
      .parse(['--help']).should.eql
        help: true
    
    it 'with command', ->
      parameters
        commands: 'parent':
          commands: 'child':
            options:  'my_argument':
              required: true
      .parse(['parent', 'child', '--help']).should.eql
        command: ['parent', 'child']
        help: true
    
    it 'stop command nested discovery', ->
      parameters
        commands: 'parent':
          commands: 'child':
            options:  'my_argument':
              required: true
      .parse(['parent', '--help', 'child']).should.eql
        command: ['parent']
        help: true
      
