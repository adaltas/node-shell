
fs = require('fs').promises
os = require 'os'
shell = require '../../lib'

describe 'router.load', ->

  it 'application route', ->
    mod = "#{os.tmpdir()}/node_params"
    await fs.writeFile "#{mod}.coffee", 'module.exports = ({params}) -> params.my_argument'
    shell
      handler: mod
      options: 'my_argument': {}
    .route ['--my_argument', 'my value']
    .should.eql 'my value'
    await fs.unlink "#{mod}.coffee"

  it 'command route', ->
    mod = "#{os.tmpdir()}/node_params"
    await fs.writeFile "#{mod}.coffee", 'module.exports = ({params}) -> params.my_argument'
    shell
      commands:
        'my_command':
          handler: mod
          options: 'my_argument': {}
    .route ['my_command', '--my_argument', 'my value']
    .should.eql 'my value'
    await fs.unlink "#{mod}.coffee"
