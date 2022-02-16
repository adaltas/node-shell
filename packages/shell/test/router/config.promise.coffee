
path = require 'path'
shell = require '../../src'
{ Readable, Writable } = require('stream')

describe 'router.config.promise', ->
  
  it 'wrap error', ->
    shell
      options:
        'my_argument': {}
      router:
        promise: true
      handler: -> throw Error 'catch me'
    .route ['--my_argument', 'my value']
    .should.be.rejectedWith 'catch me'

  it 'pass user arguments', ->
    shell
      options:
        'my_argument': {}
      router:
        promise: true
      handler: (context, callback) ->
        callback 'value'
    .route ['--my_argument', 'my value'], (value) -> value
    .should.be.resolvedWith 'value'
  
