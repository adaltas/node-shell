
import { Readable, Writable } from 'node:stream'
import path from 'node:path'
import {shell} from '../../lib/index.js'
import filedirname from '../../lib/utils/filedirname.js'
{__dirname} = filedirname import.meta.url

describe 'router.config.router', ->
  
  describe 'router', ->
    
    it "accept string (eg stderr)", ->
      shell({})
      .config().get().router.should.eql
        handler: 'shell/routes/help'
        promise: false
        stderr: process.stderr
        stderr_end: false
        stdin: process.stdin
        stdout: process.stdout
        stdout_end: false
          
    it "pass custom readable and writable streams", ->
      shell
        router:
          stderr: new Writable()
          stdin: new Readable()
          stdout: new Writable()
      .config().get().router.should.eql
        handler: 'shell/routes/help'
        promise: false
        stderr: new Writable()
        stderr_end: false
        stdin: new Readable()
        stdout: new Writable()
        stdout_end: false

  describe 'options', ->
  
    it 'auto generate the help options in application', ->
      shell({})
      .config().get().options.should.eql
        'help':
          cascade: true
          description: 'Display help information'
          help: true
          name: 'help'
          type: 'boolean'
          shortcut: 'h'
      shell({})
      .config().get().shortcuts.should.eql
        'h': 'help'
          
    it 'auto generate the help options in command with sub-command', ->
      shell
        commands:
          'server':
            commands:
              'start': {}
      .config(['server']).get().options.should.eql
        'help':
          cascade: true
          description: 'Display help information'
          help: true
          name: 'help'
          shortcut: 'h'
          transient: true
          type: 'boolean'
  
  describe 'commands', ->
  
    it 'overwrite command description', ->
      shell
        commands:
          'start':
            options: 'myopt': {}
          'help':
            description: 'Overwrite description'
      .config().get().commands.help.should.eql
        name: 'help'
        help: true
        description: 'Overwrite description'
        command: ['help']
        main:
          name: 'name'
          description: 'Help about a specific command'
        handler: 'shell/routes/help'
        strict: false
        shortcuts: {}
        options: {}
        commands: {}

    it 'does not conflict with default description', ->
      shell
        commands:
          'start': {}
          'help': {}
      .config(['help']).get().description.should.eql 'Display help information'
