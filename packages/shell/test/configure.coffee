
import path from 'path'
import {shell} from '../lib/index.js'
import filedirname from '../lib/utils/filedirname.js'
{__dirname} = filedirname import.meta.url

describe 'configure', ->

  describe 'normalisation', ->

    it 'is immutable', ->
      config = {}
      shell config
      config.should.eql {}

    it 'empty without command does not throw errors', ->
      shell({}).confx().get()

    it 'set default command name as "command" if commands available', ->
      shell
        commands:
          'my_cmd': {}
      .confx().get().command.should.eql 'command'

    it 'nested empty commands', ->
      shell
        commands: 'parent_cmd':
          commands: 'child_cmd': {}
      .confx().get().commands
      .should.eql
        'parent_cmd':
          name: 'parent_cmd'
          description: 'No description yet for the parent_cmd command'
          command: ['parent_cmd']
          options:
            'help':
              cascade: true
              description: 'Display help information'
              help: true
              name: 'help'
              shortcut: 'h'
              transient: true
              type: 'boolean'
          strict: false
          shortcuts:
            'h': 'help'
          commands:
            'child_cmd':
              name: 'child_cmd'
              description: 'No description yet for the child_cmd command'
              command: ['parent_cmd', 'child_cmd']
              options:
                'help':
                  cascade: true
                  description: 'Display help information'
                  help: true
                  name: 'help'
                  shortcut: 'h'
                  transient: true
                  type: 'boolean'
              commands: {}
              strict: false
              shortcuts:
                'h': 'help'
        'help':
          name: 'help'
          help: true
          description: 'Display help information'
          command: ['help']
          main:
            name: 'name'
            description: 'Help about a specific command'
          handler: 'shell/routes/help'
          strict: false
          options: {}
          commands: {}
          shortcuts: {}
