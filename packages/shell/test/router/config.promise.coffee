
path = require 'path'
shell = require '../../lib'
{ Readable, Writable } = require('stream')

describe 'router.config.promise', ->
  
  it 'handler throw error', ->
    shell
      options:
        'my_argument': {}
      router:
        promise: true
      handler: -> throw Error 'catch me'
    .route ['--my_argument', 'my value']
    .should.be.rejectedWith 'catch me'

  it 'handler return value', ->
    shell
      options:
        'my_argument': {}
      router:
        promise: true
      handler: (context, callback) ->
        callback 'value'
    .route ['--my_argument', 'my value'], (value) -> value
    .should.be.resolvedWith 'value'
      
  it 'handler return undefined', ->
    shell
      options:
        'my_argument': {}
      router:
        promise: true
      handler: (->)
    .route ['--my_argument', 'my value']
    .should.be.resolvedWith undefined
  
