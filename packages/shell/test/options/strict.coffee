
import {shell} from '../../lib/index.js'
  
describe 'options.strict', ->

  it 'throw error for an undefined option', ->
    app = shell strict: true
    (->
      app.parse ['--myoption', 'my', '--command']
    ).should.throw 'Invalid Argument: the argument --myoption is not a valid option'
    (->
      app.compile
        myoption: true
    ).should.throw 'Invalid Parameter: the property --myoption is not a registered argument'

  it 'throw error for an undefined argument inside an command', ->
    app = shell strict: true, commands: 'mycommand': {}
    (->
      app.parse ['mycommand', '--myoption', 'my', '--command']
    ).should.throw 'Invalid Argument: the argument --myoption is not a valid option'
    (->
      app.compile
        command: 'mycommand'
        myoption: true
    ).should.throw 'Invalid Parameter: the property --myoption is not a registered argument'
