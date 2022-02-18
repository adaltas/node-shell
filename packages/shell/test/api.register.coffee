
shell = require '../lib'

describe 'api.register', ->
  
  it 'return current instance', ->
    app = shell()
    app.register
      hook_sth: (context, handler) -> handler
    .should.equal app
