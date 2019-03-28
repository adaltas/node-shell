
parameters = require '../src'
  
describe 'options.discovery', ->

  it 'discover unregistered options', ->
    params = parameters()
    params.parse(['--myoption', 'my value']).should.eql
      myoption: 'my value'
    ['--myoption', 'my value'].should.eql params.stringify 
      myoption: 'my value'

  it 'discover unregistered options in command', ->
    params = parameters commands: [name: 'mycommand']
    params.parse(['mycommand', '--myoption', 'my value']).should.eql
      command: 'mycommand'
      myoption: 'my value'
    ['mycommand', '--myoption', 'my value'].should.eql params.stringify
      command: 'mycommand'
      myoption: 'my value'

  it 'deal with boolean', ->
    params = parameters()
    params.parse(['--myoption']).should.eql
      myoption: true
    ['--myoption'].should.eql params.stringify 
      myoption: true
