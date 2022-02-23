
import {shell} from '../../lib/index.js'

describe 'config.main.api', ->
  
  describe 'get', ->

    it 'for application', ->
      shell
        options: 'config': {}
        main: 'leftover'
      .config().main.get().should.eql
        name: 'leftover'

    it 'for a command', ->
      shell
        commands: 'app': commands: 'server':
          main: 'leftover'
      .config(['app', 'server']).main.get()
      .should.eql
        name: 'leftover'
          
  describe 'set', ->

    it 'for application', ->
      shell {}
      .config().main
      .set('leftover')
      .get().should.eql
        name: 'leftover'
