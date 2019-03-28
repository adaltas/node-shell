
parameters = require '../src'

describe 'api.stringify', ->
  
  describe 'options script', ->

    it 'should prefix with node path and executed script', ->
      parameters
        commands: [
          name: 'start'
          options: [
            name: 'myparam'
          ]
        ]
      .stringify
        command: 'start'
        myparam: 'my value'
      ,
        script: './bin/myscript'
      .should.eql [process.execPath, './bin/myscript', 'start', '--myparam', 'my value']
