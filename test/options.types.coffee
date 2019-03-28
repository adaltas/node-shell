
parameters = require '../src'
  
describe 'options.type', ->

  describe 'string', ->

    it 'is default type', ->
      params = parameters commands: [
        name: 'start'
        options: [
          name: 'watch'
          shortcut: 'w'
        ]
      ]
      params.parse(['start', '--watch', __dirname]).should.eql
        command: 'start'
        watch: __dirname
      params.stringify 
        command: 'start'
        watch: __dirname
      .should.eql ['start', '--watch', __dirname]

  describe 'boolean', ->

    it 'handle boolean option', ->
      params = parameters commands: [
        name: 'start'
        options: [
          name: 'strict'
          shortcut: 's'
          type: 'boolean'
        ]
      ]
      params.parse(['start', '-s']).should.eql
        command: 'start'
        strict: true
      params.stringify 
        command: 'start'
        strict: true
      .should.eql ['start', '--strict']

    it 'bypass a boolean option set to null', ->
      params = parameters
        options: [
          name: 'detached'
          shortcut: 'd'
          type: 'boolean'
        ]
      [].should.eql params.stringify 
        detached: null

  describe 'integer', ->

    it 'handle shortcut', ->
      params = parameters commands: [
        name: 'start'
        options: [
          name: 'integer'
          shortcut: 'i'
          type: 'integer'
        ]
      ]
      params.parse(['start', '-i', '5']).should.eql
        command: 'start'
        integer: 5
      params.stringify 
        command: 'start'
        integer: 5
      .should.eql ['start', '--integer', '5']

  describe 'array', ->

    it 'handle shortcut', ->
      params = parameters commands: [
        name: 'start'
        options: [
          name: 'array'
          shortcut: 'a'
          type: 'array'
        ]
      ]
      params.parse(['start', '-a', '3,2,1']).should.eql
        command: 'start'
        array: ['3','2','1']
      params.stringify 
        command: 'start'
        array: ['3','2','1']
      .should.eql ['start', '--array', '3,2,1']

    it 'handle multiple properties', ->
      params = parameters commands: [
        name: 'start'
        options: [
          name: 'array'
          shortcut: 'a'
          type: 'array'
        ]
      ]
      params.parse(['start', '-a', '3', '-a', '2', '-a', '1']).should.eql
        command: 'start'
        array: ['3','2','1']
      params.stringify 
        command: 'start'
        array: ['3','2','1']
      .should.eql ['start', '--array', '3,2,1']

    it 'handle empty values', ->
      params = parameters commands: [
        name: 'start'
        options: [
          name: 'my_array'
          type: 'array'
        ]
      ]
      params.parse(['start', '--my_array', '', '--my_array', '2', '--my_array', '']).should.eql
        command: 'start'
        my_array: ['','2','']
      params.stringify 
        command: 'start'
        array: ['','2','']
      .should.eql ['start', '--array', ',2,']
