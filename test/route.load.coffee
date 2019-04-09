
fs = require 'fs'
os = require 'os'
parameters = require '../src'
  
describe 'route.load', ->

  it 'application route', ->
    mod = "#{os.tmpdir()}/node_params"
    fs.writeFileSync "#{mod}.coffee", 'module.exports = ({params}) -> params.my_argument'
    parameters
      route: mod
      options: [
        name: 'my_argument'
      ]
    .route ['--my_argument', 'my value']
    .should.eql 'my value'

  it 'command route', ->
    mod = "#{os.tmpdir()}/node_params"
    fs.writeFileSync "#{mod}.coffee", 'module.exports = ({params}) -> params.my_argument'
    parameters
      commands:
        'my_command':
          route: mod
          options: [
            name: 'my_argument'
          ]
    .route ['my_command', '--my_argument', 'my value']
    .should.eql 'my value'
