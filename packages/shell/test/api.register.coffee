
import {shell} from '../lib/index.js'

describe 'api.register', ->
  
  it 'return current instance', ->
    app = shell()
    app.register
      hook_sth: (context, handler) -> handler
    .should.equal app
