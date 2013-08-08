
should = require 'should'
parameters = require "../#{if process.env.PARAMETERS_COV then 'lib-cov' else 'src'}"
  
describe 'options discovery', ->

  it 'discover unregistered options', ->
    params = parameters()
    params.parse(['--myoption', 'my value']).should.eql
      myoption: 'my value'
    ['--myoption', 'my value'].should.eql params.stringify 
      myoption: 'my value'

  it 'discover unregistered options in action', ->
    params = parameters actions: [name: 'myaction']
    params.parse(['myaction', '--myoption', 'my value']).should.eql
      action: 'myaction'
      myoption: 'my value'
    ['myaction', '--myoption', 'my value'].should.eql params.stringify
      action: 'myaction'
      myoption: 'my value'

  it 'deal with boolean', ->
    params = parameters()
    params.parse(['--myoption']).should.eql
      myoption: true
    ['--myoption'].should.eql params.stringify 
      myoption: true



