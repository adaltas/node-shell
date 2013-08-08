
should = require 'should'
parameters = require "../#{if process.env.PARAMETERS_COV then 'lib-cov' else 'src'}"
  
describe 'options strict', ->

  it 'throw error if undefined', ->
    params = parameters strict: true
    (->
      params.parse ['--myoption', 'my', '--command']
    ).should.throw "Invalid option 'myoption'"
    (->
      params.stringify 
        myoption: true
    ).should.throw "Invalid option 'myoption'"

  it 'throw error if undefined in action', ->
    params = parameters strict: true, actions: [name: 'myaction']
    (->
      params.parse ['myaction', '--myoption', 'my', '--command']
    ).should.throw "Invalid option 'myoption'"
    (->
      params.stringify 
        action: 'myaction'
        myoption: true
    ).should.throw "Invalid option 'myoption'"



