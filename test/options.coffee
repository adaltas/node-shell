
parameters = require '../src'
  
describe 'options', ->

  it 'handle multiple options', ->
    params = parameters commands: [
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
