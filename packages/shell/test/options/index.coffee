
import {shell} from '../../lib/index.js'
  
describe 'options', ->
  
  describe 'validation', ->
    
    it 'value types', ->
      (->
        shell
          options: []
      ).should.throw 'Invalid Options: expect an object, got []'
  
  describe 'normalisation', ->
        
    it 'accept object', ->
      shell
        options:
          myparam:
            shortcut: 'm'
      .config().get().options.myparam.should.eql
        name: 'myparam'
        shortcut: 'm'
        type: 'string'
  
  describe 'usage', ->

    it 'run without main', ->
      app = shell
        options: 'myparam':
          shortcut: 'm'
      app.parse [
        '--myparam', 'my value'
      ]
      .should.eql
        myparam: 'my value'
      app.parse [
        '-m', 'my value'
      ]
      .should.eql
        myparam: 'my value'
      app.compile
        myparam: 'my value'
      .should.eql ['--myparam', 'my value']

    it 'commands with multiple options', ->
      app = shell
        commands: 'start':
          main:
            name: 'my_argument'
            required: true
          options:
            'watch':
              shortcut: 'w'
            'strict':
              shortcut: 's'
              type: 'boolean'
      app.parse [
        'start', '--watch', 'first value', '-s', 'second', '--value'
      ]
      .should.eql
        command: ['start']
        watch: 'first value'
        strict: true
        my_argument: ['second', '--value']
      app.compile
        command: ['start']
        watch: 'first value'
        strict: true
        my_argument: ['second', '--value']
      .should.eql ['start', '--watch', 'first value', '--strict', 'second', '--value']
