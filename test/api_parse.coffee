
parameters = require '../src'

describe 'parse', ->

  it 'doesnot alter params', ->
    params = parameters commands: [
      name: 'start'
      options: [
        name: 'watch'
        shortcut: 'w'
      ]
    ]
    argv = ['start', '--watch', __dirname]
    params.parse(argv)
    argv.should.eql ['start', '--watch', __dirname]

  it 'catch argument without a value because end of argv', ->
    params = parameters commands: [
      name: 'start'
      options: [
        name: 'an_int'
        type: 'integer'
      ,
        name: 'a_string'
        type: 'string'
      ,
        name: 'an_array'
        type: 'array'
      ]
    ]
    ( ->
      params.parse(['start', '--an_int'])
    ).should.throw 'Invalid Option: no value found for option "an_int"'
    ( ->
      params.parse(['start', '--a_string'])
    ).should.throw 'Invalid Option: no value found for option "a_string"'
    ( ->
      params.parse(['start', '--an_array'])
    ).should.throw 'Invalid Option: no value found for option "an_array"'

  it 'catch argument without a value because next argv is a shortcut', ->
    params = parameters commands: [
      name: 'start'
      options: [
        name: 'an_int'
        type: 'integer'
      ,
        name: 'a_string'
        type: 'string'
      ,
        name: 'an_array'
        type: 'array'
      ,
        name: 'some'
        type: 'string'
      ]
    ]
    ( ->
      params.parse(['start', '--an_int', '--some', 'thing'])
    ).should.throw 'Invalid Option: no value found for option "an_int"'
    ( ->
      params.parse(['start', '--a_string', '--some', 'thing'])
    ).should.throw 'Invalid Option: no value found for option "a_string"'
    ( ->
      params.parse(['start', '--an_array', '--some', 'thing'])
    ).should.throw 'Invalid Option: no value found for option "an_array"'
