
import { shell } from '../../lib/index.js'
  
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
