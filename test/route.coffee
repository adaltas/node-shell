
fs = require 'fs'
os = require 'os'
parameters = require '../src'
  
describe 'route', ->
  
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
