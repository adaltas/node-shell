
fs = require 'fs'
os = require 'os'
parameters = require '../src'
  
describe 'api.route', ->
  
  describe 'validate', ->
  
    it 'application requires a route definition', ->
      ( ->
        parameters {}
        .route []
      ).should.throw 'Missing route definition'
    
    it 'command requires a route definition', ->
      ( ->
        parameters
          commands:
            my_command: {}
        .route ['my_command']
      ).should.throw 'Missing "route" definition for command ["my_command"]'
  
    it 'the help command must point to a valid route handler', ->
      # Note, this test cover a valid point, when routing is enable, we must
      # ensure that there is a route for help, however
      # - the help route can be automatically created and register (eg "parameters/lib/routes/help")
      # - the below exemple is activating `helping` which is not necessary a brilliant idea
      ( ->
        parameters
          commands:
            'my_command':
              route: ({params}) -> params.my_argument
              options: [
                name: 'my_argument'
              ]
        .route ['--param', 'value']
      ).should.throw 'Missing "route" definition for help: please insert a command of name "help" with a "route" property inside'

  describe 'handler', ->
    
    it 'context is parameter instance', ->
      parameters
        route: ({params}) ->
          @should.have.property('help').which.is.a.Function()
          @should.have.property('parse').which.is.a.Function()
          @should.have.property('stringify').which.is.a.Function()
      .route []

    it 'propagate error', ->
      (->
        parameters
          options: [
            name: 'my_argument'
          ]
          route: -> throw Error 'catch me'
        .route ['--my_argument', 'my value']
      ).should.throw 'catch me'
  
  describe 'arguments', ->

    it 'pass a single info argument by default', ->
      parameters
        options: [
          name: 'my_argument'
        ]
        route: (info) ->
          Object.keys(info).should.eql ['params', 'argv', 'config']
          arguments.length.should.eql 1
      .route ['--my_argument', 'my value']

    it 'pass user arguments', (next) ->
      parameters
        options: [
          name: 'my_argument'
        ]
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
        options: [
          name: 'my_argument'
        ]
      .route ['--my_argument', 'my value']
      .should.eql 'my value'

    it 'inside a command', ->
      parameters commands: [
        name: 'my_command'
        route: ({params}) -> params.my_argument
        options: [
          name: 'my_argument'
        ]
      ]
      .route ['my_command', '--my_argument', 'my value']
      .should.eql 'my value'

  describe 'load', ->

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
