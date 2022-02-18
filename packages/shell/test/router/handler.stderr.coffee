
fs = require('fs').promises
os = require 'os'
shell = require '../../lib'
{ Writable } = require('stream')
  
describe 'handler.stdout', ->

  it "pass custom writable stream", ->
    app = shell
      router:
        stdout: new Writable
          write: (data) ->
            Buffer.isBuffer(data).should.be.true()
            data.toString().should.eql 'hello'
      handler: ({stdout}) ->
        stdout.write 'hello'
    app.route []
