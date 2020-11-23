
parameters = require '../src'

describe 'api.register', ->
  
  it 'return current instance', ->
    app = parameters()
    app.register
      hook_sth: (context, handler) -> handler
    .should.equal app
