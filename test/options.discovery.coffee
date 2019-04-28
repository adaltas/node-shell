
parameters = require '../src'
  
describe 'options.discovery', ->

  it 'discover unregistered options', ->
    app = parameters()
    app.parse [
      '--myoption', 'my value'
    ]
    .should.eql
      myoption: 'my value'
    app.stringify
      myoption: 'my value'
    .should.eql ['--myoption', 'my value']

  it 'discover unregistered options in command', ->
    app = parameters commands: 'mycommand': {}
    app.parse(['mycommand', '--myoption', 'my value']).should.eql
      command: ['mycommand']
      myoption: 'my value'
    app.stringify
      command: ['mycommand']
      myoption: 'my value'
    .should.eql ['mycommand', '--myoption', 'my value']

  it 'deal with boolean', ->
    app = parameters()
    app.parse(['--myoption']).should.eql
      myoption: true
    app.stringify
      myoption: true
    .should.eql ['--myoption']
