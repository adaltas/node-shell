
{ Writable } = require 'stream'
parameters = require '../src'

describe 'api.register', ->
  
  it 'return current instance', ->
    app = parameters()
    app.register
      hook_sth: ({}, handler) -> handler
    .should.equal app
