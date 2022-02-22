
import { Writable } from 'stream'
import {shell} from '../../lib/index.js'

writer = (callback) ->
  chunks = []
  new Writable
    write: (chunk, encoding, callback) ->
      chunks.push chunk.toString()
      callback()
  .on 'finish', ->
    callback chunks.join ''

describe 'router.hook', ->
    
  it 'shell:router:call validate context', ->
    shell
      handler: (->)
    .plugins.register
      'shell:router:call': (context, handler) ->
        Object.keys(context).sort().should.eql [
          "args", "argv", "command", "error", "params", "stderr", "stderr_end", "stdin", "stdout", "stdout_end"
        ]
        handler
    .route []
        
  it 'shell:router:call modify shell', (next) ->
    shell
      handler: ({stdout}) ->
        stdout.write 'gotit'
        stdout.end()
    .plugins.register
      hooks:
        'shell:router:call': (context, handler) ->
          context.stdout = writer (data) ->
            data.should.eql 'gotit'
            next()
          handler
    .route []
