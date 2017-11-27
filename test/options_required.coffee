
parameters = require '../src'

describe 'options required', ->
  
  describe 'optional', ->

    it 'may be optional with string', ->
      params = parameters commands: [
        name: 'mycommand'
        options: [
          name: 'my_argument'
        ]
      ]
      params.parse(['mycommand']).should.eql
        command: 'mycommand'
      params.stringify 
        command: 'mycommand'
      .should.eql ['mycommand']

    it 'may be optional with array', ->
      params = parameters commands: [
        name: 'mycommand'
        options: [
          name: 'my_argument'
          type: 'array'
        ]
      ]
      params.parse(['mycommand']).should.eql
        command: 'mycommand'
      params.stringify 
        command: 'mycommand'
      .should.eql ['mycommand']

  describe 'enforce', ->

    it 'honors required true if value is provided', ->
      params = parameters commands: [
        name: 'mycommand'
        options: [
          name: 'my_argument'
          required: true
        ]
      ]
      params.parse(['mycommand', '--my_argument', 'my --value']).should.eql
        command: 'mycommand'
        my_argument: 'my --value'
      params.stringify
        command: 'mycommand'
        my_argument: 'my --value'
      .should.eql ['mycommand', '--my_argument', 'my --value']

    it 'honors required true if no value provided', ->
      params = parameters commands: [
        name: 'mycommand'
        options:  [
          name: 'my_argument'
          required: true
        ]
      ]
      (->
        params.parse ['mycommand']
      ).should.throw 'Required option argument "my_argument"'
      (->
        params.stringify
          command: 'mycommand'
      ).should.throw 'Required option argument "my_argument"'
  
  describe 'compatible with help', ->
    
    it 'without command', ->
      params = parameters()
      params.parse(['--help']).should.eql
        help: true
    
    it 'with command', ->
      params = parameters
        commands: [
          name: 'parent'
          commands: [
            name: 'child'
            options:  [
              name: 'my_argument'
              required: true
            ]
          ]
        ]
      params.parse(['parent', 'child', '--help']).should.eql
        command: ['parent', 'child']
        help: true
    
    it 'stop command nested discovery', ->
      params = parameters
        commands: [
          name: 'parent'
          commands: [
            name: 'child'
            options:  [
              name: 'my_argument'
              required: true
            ]
          ]
        ]
      params.parse(['parent', '--help', 'child']).should.eql
        command: 'parent'
        help: true
      
