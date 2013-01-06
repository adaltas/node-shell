
should = require 'should'
parameters = require '..'

describe 'api', ->

  it 'define action and options as an object or an array', ->
    asArrays = parameters actions: [
      name: 'start'
      options: [
        name: 'myparam'
      ]
    ]
    asObjects = parameters actions:
      name: 'start'
      options:
        name: 'myparam'
    asObjects.should.eql asArrays

  describe 'encode'

    it 'should prefix with node path and executed script', ->
      params = parameters actions: [
        name: 'start'
        options: [
          name: 'myparam'
        ]
      ]
      [process.execPath, './bin/myscript', 'start', '--myparam', 'my value'].should.eql params.encode './bin/myscript',
        action: 'start'
        myparam: 'my value'