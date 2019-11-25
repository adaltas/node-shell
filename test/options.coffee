
parameters = require '../src'
  
describe 'options', ->
  
  describe 'validation', ->
    
    it 'value types', ->
      (->
        parameters
          options: []
      ).should.throw 'Invalid Options: expect an object, got []'
  
  describe 'normalisation', ->
        
    it 'accept object', ->
      parameters
        options:
          myparam:
            shortcut: 'm'
      .config.options.myparam.should.eql
        name: 'myparam'
        shortcut: 'm'
        type: 'string'
  
  describe 'usage', ->

    it 'run without main', ->
      app = parameters
        options: 'myparam':
          shortcut: 'm'
      app.parse [
        '--myparam', 'my value'
      ]
      .should.eql
        myparam: 'my value'
      app.parse [
        '-m', 'my value'
      ]
      .should.eql
        myparam: 'my value'
      app.compile
        myparam: 'my value'
      .should.eql ['--myparam', 'my value']

    it 'commands with multiple options', ->
      app = parameters
        commands: 'start':
          main:
            name: 'my_argument'
            required: true
          options:
            'watch':
              shortcut: 'w'
            'strict':
              shortcut: 's'
              type: 'boolean'
      app.parse [
        'start', '--watch', __dirname, '-s', 'my', '--value'
      ]
      .should.eql
        command: ['start']
        watch: __dirname
        strict: true
        my_argument: ['my', '--value']
      app.compile
        command: ['start']
        watch: __dirname
        strict: true
        my_argument: ['my', '--value']
      .should.eql ['start', '--watch', __dirname, '--strict', 'my', '--value']
