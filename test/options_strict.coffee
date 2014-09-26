
should = require 'should'
parameters = require "../#{if process.env.PARAMETERS_COV then 'lib-cov' else 'src'}"
  
describe 'options strict false', ->

  it 'throw error for an undefined shortcut', ->
    # Test a boolean (no value) argument
    params = parameters()
    (->
      params.parse ['-c']
    ).should.throw "Invalid shortcut 'c'"
    (->
      params.parse ['-c', 'a value']
    ).should.throw "Invalid shortcut 'c'"
  
describe 'options strict true', ->

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
    ).should.throw "Invalid shortcut 'c'"

  it 'throw error for an undefined argument inside an command', ->
    params = parameters strict: true, commands: [name: 'mycommand']
    (->
      params.parse ['mycommand', '--myoption', 'my', '--command']
    ).should.throw "Invalid option 'myoption'"
    (->
      params.stringify
        command: 'mycommand'
        myoption: true
    ).should.throw "Invalid option 'myoption'"

  it 'throw error for an undefined shortcut inside an command', ->
    # Test a boolean (no value) argument
    params = parameters strict: true, commands: [name: 'mycommand']
    (->
      params.parse ['mycommand', '-c']
    ).should.throw "Invalid shortcut 'c'"



