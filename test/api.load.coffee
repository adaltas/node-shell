
fs = require 'fs'
os = require 'os'
parameters = require '../src'
promise = require('promise')
  
describe 'api.load', ->

  it 'load relative to require.main', ->
    cwd = process.cwd()
    process.chdir os.tmpdir()
    await promise.denodeify(fs.writeFile)  "#{os.tmpdir()}/relative_module.coffee", 'module.exports = ({params}) -> params.my_argument'
    parameters
      route: './relative_module'
      options: [
        name: 'my_argument'
      ]
    .route ['--my_argument', 'my value']
    .should.eql 'my value'
    process.chdir cwd
    await promise.denodeify(fs.unlink) "#{os.tmpdir()}/relative_module.coffee"

  it 'load is not a string', ->
    (->
      parameters
        name: 'start'
      .load {name: 'something'}
    )
    .should.throw 'Invalid Load Argument: load is expecting string, got {"name":"something"}'
