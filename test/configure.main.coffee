parameters = require '../src'

describe 'configure.main', ->

  it 'accept main as a string', ->
    parameters
      main: 'leftover'
    .config.main.should.eql
      name: 'leftover'

  it 'accept main in a command as a string', ->
    parameters
      commands: 'start':
        main: 'leftover'
    .config.commands.start.main.should.eql
      name: 'leftover'
