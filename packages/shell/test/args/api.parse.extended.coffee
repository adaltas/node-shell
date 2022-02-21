
import {shell} from '../../lib/index.js'

describe 'api.parse.extended', ->

  it 'overwrite flatten mode', ->
    shell
      options: 'my_option': {}
    .parse ['--my_option', 'my value'], extended: true
    .should.eql [my_option: 'my value']

  it 'overwrite extended mode', ->
    shell
      options: 'my_option': {}
      extended: true
    .parse ['--my_option', 'my value'], extended: false
    .should.eql my_option: 'my value'
