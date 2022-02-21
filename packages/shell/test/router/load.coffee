
import fs from 'node:fs/promises'
import os from 'node:os'
import {Writable} from 'node:stream'
import {shell} from '../../lib/index.js'

writer = (callback) ->
  chunks = []
  new Writable
    write: (chunk, encoding, callback) ->
      chunks.push chunk.toString()
      callback()
  .on 'finish', ->
    callback chunks.join ''

describe 'router.load', ->

  it 'application route', ->
    mod = "#{os.tmpdir()}/node_params.coffee"
    await fs.writeFile "#{mod}", 'export default ({params}) -> params.my_argument'
    await shell
      handler: mod
      options: 'my_argument': {}
    .route ['--my_argument', 'my value']
    .should.be.resolvedWith 'my value'
    await fs.unlink "#{mod}"

  it 'command route', ->
    mod = "#{os.tmpdir()}/node_params.coffee"
    await fs.writeFile "#{mod}", 'export default ({params}) -> params.my_argument'
    await shell
      commands:
        'my_command':
          handler: mod
          options: 'my_argument': {}
    .route ['my_command', '--my_argument', 'my value']
    .should.be.resolvedWith 'my value'
    await fs.unlink "#{mod}"

  it 'error to load route', ->
    mod = "#{os.tmpdir()}/router_load_handler_invalid.coffee"
    await fs.writeFile "#{mod}", 'Oh no, this is so invalid'
    await shell
      handler: mod
      options: 'my_argument': {}
      router:
        stderr: writer (output) ->
          output.should.match /^\s+Fail to load route. Message is: Oh is not defined/
          output.should.match /^\s+myapp - No description yet/m
          # next()
        stderr_end: true
    .route ['--my_argument', 'my value']
    await fs.unlink "#{mod}"
