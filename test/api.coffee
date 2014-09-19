
should = require 'should'
parameters = require "../#{if process.env.PARAMETERS_COV then 'lib-cov' else 'src'}"

describe 'api', ->

  describe 'constructor', ->
    
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

  describe 'parse', ->
    
    it 'should not alter params', ->
      params = parameters commands: [
        name: 'start'
        options: [
          name: 'watch'
          shortcut: 'w'
        ]
      ]
      argv = ['start', '--watch', __dirname]
      params.parse(argv)
      argv.should.eql ['start', '--watch', __dirname]

  describe 'stringify', ->

    it 'should prefix with node path and executed script', ->
      params = parameters commands: [
        name: 'start'
        options: [
          name: 'myparam'
        ]
      ]
      [process.execPath, './bin/myscript', 'start', '--myparam', 'my value'].should.eql params.stringify './bin/myscript',
        command: 'start'
        myparam: 'my value'
