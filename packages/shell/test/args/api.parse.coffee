
import {shell} from '../../lib/index.js'

describe 'api.parse', ->

  it 'does not alter input arguments', ->
    app = shell
      commands: 'start':
        options: 'my_option':
          shortcut: 'w'
    argv = ['start', '--my_option', 'my value']
    app.parse(argv)
    argv.should.eql ['start', '--my_option', 'my value']

  it 'catch argument without a value because end of argv', ->
    app = shell
      commands: 'start':
        options:
          'an_int':
            type: 'integer'
          'a_string':
            type: 'string'
          'an_array':
            type: 'array'
    ( ->
      app.parse(['start', '--an_int'])
    ).should.throw 'Invalid Option: no value found for option "an_int"'
    ( ->
      app.parse(['start', '--a_string'])
    ).should.throw 'Invalid Option: no value found for option "a_string"'
    ( ->
      app.parse(['start', '--an_array'])
    ).should.throw 'Invalid Option: no value found for option "an_array"'

  it 'catch argument without a value because next argv is a shortcut', ->
    app = shell
      commands: 'start':
        options:
          'an_int':
            type: 'integer'
          'a_string':
            type: 'string'
          'an_array':
            type: 'array'
          'some':
            type: 'string'
    ( ->
      app.parse(['start', '--an_int', '--some', 'thing'])
    ).should.throw 'Invalid Option: no value found for option "an_int"'
    ( ->
      app.parse(['start', '--a_string', '--some', 'thing'])
    ).should.throw 'Invalid Option: no value found for option "a_string"'
    ( ->
      app.parse(['start', '--an_array', '--some', 'thing'])
    ).should.throw 'Invalid Option: no value found for option "an_array"'
