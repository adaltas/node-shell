
parameters = require '../src'

describe 'api constructor', ->
    
  it 'define command and options as an object or an array', ->
    asArrays = parameters commands: [
      name: 'start'
      options: [
        name: 'myparam'
      ]
    ]
    asObjects = parameters commands:
      name: 'start'
      options:
        name: 'myparam'
    asObjects.should.eql asArrays
