
import {shell} from '../../lib/index.js'

describe 'config.main.api', ->
  
  describe 'get', ->

    it 'for application', ->
      shell
        options: 'config': {}
        main: 'leftover'
      .confx().main.get().should.eql
        name: 'leftover'

    it 'for a command', ->
      shell
        commands: 'app': commands: 'server':
          main: 'leftover'
      .confx(['app', 'server']).main.get()
      .should.eql
        name: 'leftover'
          
  describe 'set', ->

    it 'for application', ->
      shell {}
      .confx().main
      .set('leftover')
      .get().should.eql
        name: 'leftover'
