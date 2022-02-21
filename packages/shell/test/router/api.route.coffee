
import {shell} from '../../lib/index.js'

describe 'router.api', ->
    
  it "throw error", ->
    (->
      shell().route 'oh no'
    ).should.throw [
      'Invalid Router Arguments:'
      'first argument must be a context object or the argv array,'
      'got "oh no"'
    ].join ' '
      
  it "accept an object", ->
    shell
      handler: ({user_param, params}) ->
        return "got: #{user_param} and #{params.opt}"
    .route
      argv: ['--opt', 'param value']
      user_param: 'user value'
    .should.eql 'got: user value and param value'
    
