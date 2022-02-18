
fs = require('fs').promises
os = require 'os'
shell = require '../lib'
  
describe 'api.load', ->

  it 'load relative to require.main', ->
    cwd = process.cwd()
    process.chdir os.tmpdir()
    await fs.writeFile "#{os.tmpdir()}/relative_module.coffee", '''
    module.exports = (params) -> params
    '''
    mod = shell().load "#{os.tmpdir()}/relative_module.coffee"
    mod('my value').should.eql 'my value'
    process.chdir cwd
    await fs.unlink "#{os.tmpdir()}/relative_module.coffee"

  it 'load is not a string', ->
    (->
      shell
        name: 'start'
      .load {name: 'something'}
    )
    .should.throw 'Invalid Load Argument: load is expecting string, got {"name":"something"}'
