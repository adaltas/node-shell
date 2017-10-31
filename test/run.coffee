
fs = require 'fs'
os = require 'os'
parameters = require '../src'
  
describe 'options module', ->
  
  describe 'function', ->
    
    it 'context is parameter instance', ->
      parameters
        run: (params) ->
          @should.have.property('help').which.is.a.Function()
          @should.have.property('parse').which.is.a.Function()
          @should.have.property('stringify').which.is.a.Function()
      .run []
        
    it '1st arg is params', ->
      parameters
        options: [
          name: 'my_argument'
        ]
        run: (params) ->
          params.my_argument.should.eql 'my value'
      .run ['--my_argument', 'my value']
        
    it '2nd arg is argv', ->
      parameters
        options: [
          name: 'my_argument'
        ]
        run: (params, argv) ->
          argv.should.eql ['--my_argument', 'my value']
      .run ['--my_argument', 'my value']
        
    it '3rd arg is config', ->
      parameters
        options: [
          name: 'my_argument'
        ]
        run: (params, argv, config) ->
          config.options[0].name.should.eql 'my_argument'
      .run ['--my_argument', 'my value']
        
    it 'return value is passed', ->
      parameters
        options: [
          name: 'my_argument'
        ]
        run: -> 'catch me'
      .run ['--my_argument', 'my value']
      .should.eql 'catch me'
    
    it 'pass user arguments', (next) ->
      parameters
        options: [
          name: 'my_argument'
        ]
        run: (my_arg, my_callback, my_params) ->
          err = Error 'Das ist kaput' unless my_params['my_argument'] is 'my value'
          my_callback err, my_arg
      .run ['--my_argument', 'my value'], 'sth', (err, my_arg)->
        my_arg.should.eql 'sth' unless err
        next err
    
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