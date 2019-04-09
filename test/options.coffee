
parameters = require '../src'
  
describe 'options', ->
  
  describe 'normalisation', ->
    
    it 'accept array', ->
      app = parameters
        options: [
          name: 'myparam'
          shortcut: 'm'
        ]
      app.config.options.myparam.should.eql
        name: 'myparam'
        shortcut: 'm'
        type: 'string'
        
    it 'accept object', ->
      app = parameters
        options:
          myparam:
            shortcut: 'm'
      app.config.options.myparam.should.eql
        name: 'myparam'
        shortcut: 'm'
        type: 'string'
  
  describe 'usage', ->

    it 'run without main', ->
      app = parameters
        options: [
          name: 'myparam'
          shortcut: 'm'
        ]
      app.parse(['--myparam', 'my value']).should.eql
        myparam: 'my value'
      app.parse(['-m', 'my value']).should.eql
        myparam: 'my value'
      app.stringify 
        myparam: 'my value'
      .should.eql ['--myparam', 'my value']

    it 'commands with multiple options', ->
      app = parameters
        commands: [
          name: 'start'
          main: 
            name: 'my_argument'
            required: true
          options: [
            name: 'watch'
            shortcut: 'w'
          ,
            name: 'strict'
            shortcut: 's'
            type: 'boolean'
          ]
        ]
      app.parse(
        ['start', '--watch', __dirname, '-s', 'my', '--value']
      ).should.eql
        command: ['start']
        watch: __dirname
        strict: true
        my_argument: ['my', '--value']
      app.stringify 
        command: ['start']
        watch: __dirname
        strict: true
        my_argument: ['my', '--value']
      .should.eql ['start', '--watch', __dirname, '--strict', 'my', '--value']
