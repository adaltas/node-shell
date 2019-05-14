
parameters = require '../src'

describe 'api.compile.script', ->

  it 'should prefix with node path and executed script', ->
    parameters
      commands: 'start':
        options: 'myparam': {}
    .compile
      command: 'start'
      myparam: 'my value'
    ,
      script: './bin/myscript'
    .should.eql [process.execPath, './bin/myscript', 'start', '--myparam', 'my value']
