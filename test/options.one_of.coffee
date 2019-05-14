
parameters = require '../src'
  
describe 'options.one_of', ->
  
  it 'match elements in an array', ->
    app = parameters
      commands: 'start':
        options: 'array':
          shortcut: 'a'
          type: 'array'
          one_of: ['1', '2']
    app.parse(['start', '-a', '1', '-a', '2'])
    .should.eql
      command: ['start']
      array: ['1','2']
    app.compile
      command: ['start']
      array: ['1','2']
    .should.eql ['start', '--array', '1,2']
      
  it 'dont match elements in an array', ->
    app = parameters commands: 'start':
      options: 'array':
        shortcut: 'a'
        type: 'array'
        one_of: ['1', '3']
    (->
      app.parse(['start', '-a', '1', '-a', '2'])
    ).should.throw 'Invalid Argument Value: the value of option "array" must be one of ["1","3"], got "2"'
    (->
      app.compile command: ['start'], array: ['1','2']
    ).should.throw 'Invalid Parameter Value: the value of option "array" must be one of ["1","3"], got "2"'
  
  it 'ensure optional argument are optional', ->
    parameters
      commands: 'start':
        options: 'array':
          shortcut: 'a'
          type: 'array'
          one_of: ['1', '3']
    .parse(['start'])
    
