
should = require 'should'
parameters = require "../#{if process.env.PARAMETERS_COV then 'lib-cov' else 'src'}"
  
describe 'options strict', ->

  it 'throw error for an undefined argument', ->
    params = parameters strict: true
    (->
      params.parse ['--myoption', 'my', '--command']
    ).should.throw "Invalid option 'myoption'"
    (->
      params.stringify
        myoption: true
    ).should.throw "Invalid option 'myoption'"

  it 'throw error for an undefined shortcut', ->
    # Test a boolean (no value) argument
    params = parameters strict: true
    (->
      params.parse ['-c']
    ).should.throw "Invalid option 'c'"

  it 'throw error for an undefined argument inside an action', ->
    params = parameters strict: true, actions: [name: 'myaction']
    (->
      params.parse ['myaction', '--myoption', 'my', '--command']
    ).should.throw "Invalid option 'myoption'"
    (->
      params.stringify
        action: 'myaction'
        myoption: true
    ).should.throw "Invalid option 'myoption'"

  it 'throw error for an undefined shortcut inside an action', ->
    # Test a boolean (no value) argument
    params = parameters strict: true, actions: [name: 'myaction']
    (->
      params.parse ['myaction', '-c']
    ).should.throw "Invalid option 'c'"



