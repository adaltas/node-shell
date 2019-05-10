
fs = require 'fs'
os = require 'os'
parameters = require '../../src'
promise = require('promise')

describe 'router.load', ->

  it 'application route', ->
    mod = "#{os.tmpdir()}/node_params"
    await promise.denodeify(fs.writeFile) "#{mod}.coffee", 'module.exports = ({params}) -> params.my_argument'
    parameters
      route: mod
      options: [
        name: 'my_argument'
      ]
    .route ['--my_argument', 'my value']
    .should.eql 'my value'
    await promise.denodeify(fs.unlink) "#{mod}.coffee"

  it 'command route', ->
    mod = "#{os.tmpdir()}/node_params"
    await promise.denodeify(fs.writeFile) "#{mod}.coffee", 'module.exports = ({params}) -> params.my_argument'
    parameters
      commands:
        'my_command':
          route: mod
          options: [
            name: 'my_argument'
          ]
    .route ['my_command', '--my_argument', 'my value']
    .should.eql 'my value'
    await promise.denodeify(fs.unlink) "#{mod}.coffee"
