
should = require 'should'
parameters = require "../#{if process.env.PARAMETERS_COV then 'lib-cov' else 'src'}"
  
describe 'options', ->

  it 'handle multiple options', ->
    params = parameters actions: [
      name: 'start'
      main: 
        name: 'command'
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
    params.parse(['start', '--watch', __dirname, '-s', 'my', '--command']).should.eql
      action: 'start'
      watch: __dirname
      strict: true
      command: 'my --command'
    params.stringify 
      action: 'start'
      watch: __dirname
      strict: true
      command: 'my --command'
    .should.eql ['start', '--watch', __dirname, '--strict', 'my --command']

  it 'work with no main', ->
    params = parameters 
      options: [
        name: 'myparam'
        shortcut: 'm'
      ]
    params.parse(['--myparam', 'my value']).should.eql
      myparam: 'my value'
    params.parse(['-m', 'my value']).should.eql
      myparam: 'my value'
    ['--myparam', 'my value'].should.eql params.stringify 
      myparam: 'my value'

  it 'throw error if undefined', ->
    params = parameters actions: [name: 'myaction']
    (->
      params.parse ['myaction', '--myoption', 'my', '--command']
    ).should.throw "Invalid option 'myoption'"
    (->
      params.stringify 
        action: 'myaction'
        myoption: true
    ).should.throw "Invalid option 'myoption'"

  it 'should bypass a boolean option set to null', ->
    params = parameters
      options: [
        name: 'detached'
        shortcut: 'd'
        type: 'boolean'
      ]
    [].should.eql params.stringify 
      detached: null