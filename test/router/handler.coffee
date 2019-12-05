
fs = require('fs').promises
os = require 'os'
parameters = require '../../src'
  
describe 'router.handler', ->
    
  it 'context is parameter instance', ->
    parameters
      route: ({params}) ->
        @should.have.property('help').which.is.a.Function()
        @should.have.property('parse').which.is.a.Function()
        @should.have.property('compile').which.is.a.Function()
    .route []

  it 'propagate error', ->
    (->
      parameters
        options:
          'my_argument': {}
        route: -> throw Error 'catch me'
      .route ['--my_argument', 'my value']
    ).should.throw 'catch me'
    
  it 'load with custom function handler', ->
    await fs.writeFile "#{os.tmpdir()}/renamed_module.coffee", 'module.exports = ({params}) -> "Hello"'
    parameters
      route: './something'
      load: (module) ->
        require "#{os.tmpdir()}/renamed_module.coffee" if module is './something'
    .route []
    .should.eql 'Hello'
    await fs.unlink "#{os.tmpdir()}/renamed_module.coffee"
  
  describe 'arguments', ->
    
    it 'pass a single info argument by default', ->
      parameters
        options:
          'my_argument': {}
        route: (context) ->
          Object.keys(context).sort().should.eql ['args', 'argv', 'command', 'error', 'params', 'writer']
          arguments.length.should.eql 1
      .route ['--my_argument', 'my value']

    it 'pass user arguments', (next) ->
      parameters
        options:
          'my_argument': {}
        route: ({params, argv}, my_param, callback) ->
          my_param.should.eql 'my value'
          callback.should.be.a.Function()
          callback null, 'something'
      .route ['--my_argument', 'my value'], 'my value', (err, value) ->
        value.should.eql 'something'
        next()

  describe 'returned value', ->

    it 'inside an application', ->
      parameters
        route: ({params}) -> params.my_argument
        options:
          'my_argument': {}
      .route ['--my_argument', 'my value']
      .should.eql 'my value'

    it 'inside a command', ->
      parameters
        commands: 'my_command':
          route: ({params}) -> params.my_argument
          options:
            'my_argument': {}
      .route ['my_command', '--my_argument', 'my value']
      .should.eql 'my value'
