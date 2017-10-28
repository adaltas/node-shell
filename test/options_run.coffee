
fs = require 'fs'
os = require 'os'
should = require 'should'
parameters = require '../src'
  
describe 'options module', ->
  
  describe 'without command', ->
  
    it 'run a function', ->
      params = parameters
        run: (params) -> params.my_argument
        options: [
          name: 'my_argument'
        ]
      params
      .run ['--my_argument', 'my value']
      .should.eql 'my value'

    it 'run a module', ->
      mod = "#{os.tmpdir()}/node_params"
      fs.writeFileSync "#{mod}.coffee", 'module.exports = (params) -> params.my_argument'
      params = parameters
        run: mod
        options: [
          name: 'my_argument'
        ]
      params
      .run ['--my_argument', 'my value']
      .should.eql 'my value'
        
    describe 'within command', ->
    
      it 'run a function', ->
        params = parameters commands: [
          name: 'my_command'
          run: (params) -> params.my_argument
          options: [
            name: 'my_argument'
          ]
        ]
        params
        .run ['my_command', '--my_argument', 'my value']
        .should.eql 'my value'

      it 'run a module', ->
        mod = "#{os.tmpdir()}/node_params"
        fs.writeFileSync "#{mod}.coffee", 'module.exports = (params) -> params.my_argument'
        params = parameters commands: [
          name: 'my_command'
          run: mod
          options: [
            name: 'my_argument'
          ]
        ]
        params
        .run ['my_command', '--my_argument', 'my value']
        .should.eql 'my value'
