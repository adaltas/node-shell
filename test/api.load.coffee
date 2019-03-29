
fs = require 'fs'
os = require 'os'
parameters = require '../src'
  
describe 'api.load', ->

  it 'load relative to require.main', ->
    cwd = process.cwd()
    process.chdir os.tmpdir()
    fs.writeFileSync "#{os.tmpdir()}/relative_module.coffee", 'module.exports = ({params}) -> params.my_argument'
    parameters
      run: './relative_module'
      options: [
        name: 'my_argument'
      ]
    .run ['--my_argument', 'my value']
    .should.eql 'my value'
    process.chdir cwd
    fs.unlinkSync "#{os.tmpdir()}/relative_module.coffee"

  it 'load with custom function handler', ->
    fs.writeFileSync "#{os.tmpdir()}/renamed_module.coffee", 'module.exports = ({params}) -> params.my_argument'
    parameters
      run: './something'
      load: (module) ->
        require "#{os.tmpdir()}/renamed_module.coffee" if module is './something'
      options: [
        name: 'my_argument'
      ]
    .run ['--my_argument', 'my value']
    .should.eql 'my value'
    fs.unlinkSync "#{os.tmpdir()}/renamed_module.coffee"
