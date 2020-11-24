
shell = require '../../src'

describe 'api.parse.extended', ->

  it 'overwrite flatten mode', ->
    shell
      options: 'watch': {}
    .parse ['--watch', __dirname], extended: true
    .should.eql [watch: __dirname]

  it 'overwrite extended mode', ->
    shell
      options: 'watch': {}
      extended: true
    .parse ['--watch', __dirname], extended: false
    .should.eql watch: __dirname
