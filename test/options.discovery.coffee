
parameters = require '../src'
  
describe 'options.discovery', ->

  it 'discover unregistered options', ->
    app = parameters()
    app.parse(['--myoption', 'my value']).should.eql
      myoption: 'my value'
    ['--myoption', 'my value'].should.eql app.stringify 
      myoption: 'my value'

  it 'discover unregistered options in command', ->
    app = parameters commands: [name: 'mycommand']
    app.parse(['mycommand', '--myoption', 'my value']).should.eql
      command: ['mycommand']
      myoption: 'my value'
    ['mycommand', '--myoption', 'my value'].should.eql app.stringify
      command: ['mycommand']
      myoption: 'my value'

  it 'deal with boolean', ->
    app = parameters()
    app.parse(['--myoption']).should.eql
      myoption: true
    ['--myoption'].should.eql app.stringify 
      myoption: true
