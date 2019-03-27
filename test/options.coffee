
parameters = require '../src'
  
describe 'options', ->
  
  describe 'normalisation', ->
    
    it 'accept array', ->
      params = parameters
        options: [
          name: 'myparam'
          shortcut: 'm'
        ]
      params.config.options.myparam.should.eql
        name: 'myparam'
        shortcut: 'm'
        type: 'string'
        
    it 'accept object', ->
      params = parameters
        options:
          myparam:
            shortcut: 'm'
      params.config.options.myparam.should.eql
        name: 'myparam'
        shortcut: 'm'
        type: 'string'
  
  describe 'usage', ->

    it 'run without main', ->
      params = parameters
        options: [
          name: 'myparam'
          shortcut: 'm'
        ]
      params.parse(['--myparam', 'my value']).should.eql
        myparam: 'my value'
      params.parse(['-m', 'my value']).should.eql
        myparam: 'my value'
      params.stringify 
        myparam: 'my value'
      .should.eql ['--myparam', 'my value']

    it 'commands with multiple options', ->
      params = parameters
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
      params.parse(['start', '--watch', __dirname, '-s', 'my', '--value']).should.eql
        command: 'start'
        watch: __dirname
        strict: true
        my_argument: 'my --value'
      params.stringify 
        command: 'start'
        watch: __dirname
        strict: true
        my_argument: 'my --value'
      .should.eql ['start', '--watch', __dirname, '--strict', 'my --value']
