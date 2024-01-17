
import { Writable } from 'node:stream'
import { shell } from '../../lib/index.js'

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
