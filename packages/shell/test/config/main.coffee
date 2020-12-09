
shell = require '../../src'

describe 'config.main', ->

  it 'accept main as a string', ->
    shell
      main: 'leftover'
    .config.main.should.eql
      name: 'leftover'

  it 'accept main in a command as a string', ->
    shell
      commands: 'start':
        main: 'leftover'
    .config.commands.start.main.should.eql
      name: 'leftover'
