
should = require 'should'
parameters = require "../#{if process.env.PARAMETERS_COV then 'lib-cov' else 'src'}"

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

  describe 'stringify', ->

    it 'should prefix with node path and executed script', ->
      params = parameters actions: [
        name: 'start'
        options: [
          name: 'myparam'
        ]
      ]
      [process.execPath, './bin/myscript', 'start', '--myparam', 'my value'].should.eql params.stringify './bin/myscript',
        action: 'start'
        myparam: 'my value'
