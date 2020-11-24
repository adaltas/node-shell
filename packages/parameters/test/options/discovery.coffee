
shell = require '../../src'
  
describe 'options.discovery', ->

  it 'discover unregistered options', ->
    app = shell()
    app.parse [
      '--myoption', 'my value'
    ]
    .should.eql
      myoption: 'my value'
    app.compile
      myoption: 'my value'
    .should.eql ['--myoption', 'my value']

  it 'discover unregistered options in command', ->
    app = shell commands: 'mycommand': {}
    app.parse(['mycommand', '--myoption', 'my value']).should.eql
      command: ['mycommand']
      myoption: 'my value'
    app.compile
      command: ['mycommand']
      myoption: 'my value'
    .should.eql ['mycommand', '--myoption', 'my value']

  it 'deal with boolean', ->
    app = shell()
    app.parse(['--myoption']).should.eql
      myoption: true
    app.compile
      myoption: true
    .should.eql ['--myoption']
