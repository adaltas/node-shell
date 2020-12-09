
fs = require('fs').promises
os = require 'os'
shell = require '../../src'
{ Writable } = require('stream')
  
describe 'handler.stdout', ->

  it "no argument", ->
    app = shell
      handler: ({argv}) ->
        argv.should.eql []
    app.route []

  it "with arguments", ->
    app = shell
      handler: ({argv}) ->
        argv.should.eql ['--port', 80]
    app.route ['--port', 80]
