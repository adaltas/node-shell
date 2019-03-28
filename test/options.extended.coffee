
parameters = require '../src'

describe 'options.extended', ->
    
  it 'with no argument', ->
    params = parameters
      options: [
        name: 'my_argument'
      ]
      extended: true
      run: (params, argv, config) ->
        'something'
    .run ['--my_argument', 'my value']
    .should.eql 'something'
          
  it 'with user argument', (next) ->
    parameters
      options: [
        name: 'my_argument'
      ]
      extended: true
      run: (params, argv, config, callback) ->
        callback null, 'something'
    .run ['--my_argument', 'my value'], (err, value) ->
      value.should.eql 'something'
      next()
