
fs = require('fs').promises
os = require 'os'
parameters = require '../src'
  
describe 'api.load', ->

  it 'load relative to require.main', ->
    cwd = process.cwd()
    process.chdir os.tmpdir()
    await fs.writeFile "#{os.tmpdir()}/relative_module.coffee", 'module.exports = (params) -> params'
    parameters
      name: 'start'
    .load("#{os.tmpdir()}/relative_module.coffee") "my value"
    .should.eql 'my value'
    process.chdir cwd
    await fs.unlink "#{os.tmpdir()}/relative_module.coffee"

  it 'load is not a string', ->
    (->
      parameters
        name: 'start'
      .load {name: 'something'}
    )
    .should.throw 'Invalid Load Argument: load is expecting string, got {"name":"something"}'
