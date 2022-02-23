
import {shell} from '../../lib/index.js'

describe 'config.main', ->

  it 'accept main as a string', ->
    shell
      main: 'leftover'
    .config().get().main.should.eql
      name: 'leftover'

  it 'accept main in a command as a string', ->
    shell
      commands: 'start':
        main: 'leftover'
    .config('start').get().main.should.eql
      name: 'leftover'

  it 'name must be null, object or string', ->
    (->
      shell
        # extended: true
        commands:
          'server':
            main: true
            handler: () ->
              console.log 'ok'
        strict: true
    ).should.throw [
      'Invalid Main Configuration:'
      'accepted values are string, null and object,'
      "got `true`"
    ].join ' '

  it 'name cannot equal command', ->
    (->
      shell
        # extended: true
        commands:
          'server':
            main: 'command'
            handler: () ->
              console.log 'ok'
        strict: true
    ).should.throw [
      'Conflicting Main Value:'
      'main name is conflicting with the command name,'
      'got `"command"`'
    ].join ' '
