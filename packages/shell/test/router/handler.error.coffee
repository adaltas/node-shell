
import fs from 'node:fs/promises'
import os from 'node:os'
import { Writable } from 'node:stream'
import { shell } from '../../lib/index.js'

writer = (callback) ->
  chunks = []
  new Writable
    write: (chunk, encoding, callback) ->
      chunks.push chunk.toString()
      callback()
  .on 'finish', ->
    callback chunks.join ''

describe 'router.handler.error', ->

  describe 'thrown error in function handler', ->

    it 'value', ->
      (->
        shell
          handler: -> throw Error 'catch me'
          options:
            'my_argument': {}
          router:
            stderr: writer (->)
        .route ['--my_argument', 'my value']
      ).should.throw 'catch me'

    it 'stderr', ->
      output = await new Promise( (resolve) =>
        try
          shell
            handler: -> throw Error 'catch me'
            options:
              'my_argument': {}
            router:
              stderr: writer resolve
              stderr_end: true
          .route ['--my_argument', 'my value']
      )
      output.should.containEql 'Fail to load route. Message is: catch me'

  describe 'rejected error in function handler', ->

    it 'value', ->
      shell
        handler: -> await Promise.reject Error 'catch me'
        options:
          'my_argument': {}
        router:
          stderr: writer (->)
      .route ['--my_argument', 'my value']
      .should.be.rejectedWith 'catch me'

    it 'stderr', ->
      output = await new Promise( (resolve) =>
        await shell
          handler: -> await Promise.reject Error 'catch me'
          options: 'my_argument': {}
          router:
            stderr: writer resolve
            stderr_end: true
        .route ['--my_argument', 'my value']
      )
      output.should.containEql 'Fail to load route. Message is: catch me'

  describe 'load module', ->

    it 'thrown error', ->
      try
        handler = "#{os.tmpdir()}/router_load_handler_invalid.js"
        await fs.writeFile "#{handler}", 'module.exports = () => { throw Error("catch me") }'
        output = await new Promise( (resolve) =>
          shell
            handler: handler
            options: 'my_argument': {}
            router:
              stderr: writer resolve
              stderr_end: true
          .route ['--my_argument', 'my value']
        )
        output.should.containEql 'Fail to load route. Message is: catch me'
      finally
        await fs.unlink "#{handler}"

    it 'rejected error', ->
      try
        handler = "#{os.tmpdir()}/router_load_handler_invalid.js"
        await fs.writeFile "#{handler}", 'module.exports = async () => await Promise.reject(Error("catch me"))'
        output = await new Promise( (resolve) =>
          await shell
            handler: handler
            options: 'my_argument': {}
            router:
              stderr: writer resolve
              stderr_end: true
          .route ['--my_argument', 'my value']
        )
        output.should.containEql 'Fail to load route. Message is: catch me'
      finally
        await fs.unlink "#{handler}"
