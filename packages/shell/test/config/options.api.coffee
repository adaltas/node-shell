
import {shell} from '../../lib/index.js'

describe 'config.options.api', ->
  
  describe 'list', ->

    it 'for application', ->
      shell
        options: 'config': {}
        commands: 'server': commands: 'start': {}
      .config().options.list()
      .should.eql ['config', 'help']

    it 'for a command', ->
      shell
        options: 'config': {}
        commands: 'app': commands: 'server': options:
          'host': {}
          'port': {}
      .config(['app', 'server']).options.list()
      .should.eql ['help', 'host', 'port']
    
  describe 'get', ->
    
    it 'an option (2 styles)', ->
      shell
        options: 'config': {}
        commands: 'server': commands: 'start': {}
      .config().options('config').get()
      .name.should.eql 'config'
    
    it 'selected properties from option', ->
      shell
        options: 'config': {}
        commands: 'server': commands: 'start': {}
      .config().options('config')
      .set('description', 'hello')
      .set('required', true)
      .get(['description', 'required'])
      .should.eql
        description: 'hello'
        required: true
          
  describe 'set', ->

    it 'an option in a command', ->
      shell
        options: 'config': {}
        commands: 'server': commands: 'start': {}
      .config().options('config')
      .set('description', 'hello')
      .set('required', true)
      .get().name.should.eql 'config'
        
  describe 'get_cascaded', ->
    
    it 'return the cascaded options', ->
      shell
        options: 'opt_app': cascade: true
        commands: 'server':
          options: 'opt_cmd': cascade: true
          commands: 'start': {}
      .config(['server', 'start']).options.get_cascaded()
      .should.eql
        'help':
          cascade: true
          description: 'Display help information'
          help: true
          name: 'help'
          shortcut: 'h'
          type: 'boolean'
        'opt_app':
          cascade: true
          name: 'opt_app'
          type: 'string'
        'opt_cmd':
          cascade: true
          name: 'opt_cmd'
          type: 'string'
        
  
