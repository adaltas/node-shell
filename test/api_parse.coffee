
parameters = require '../src'

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
