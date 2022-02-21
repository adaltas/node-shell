
import {shell} from '../../lib/index.js'

describe 'config.command', ->
  
  describe 'validation', ->
    
    it 'only at application level', ->
      (->
        shell
          commands: 'server':
            command: 'invalid'
            commands: 'start': {}
      ).should.throw 'Invalid Command Configuration: command property can only be declared at the application level, got command "invalid"'
