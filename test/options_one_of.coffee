
parameters = require '../src'
  
describe 'options one_of', ->
  
    it 'match elements in an array', ->
      params = parameters commands: [
        name: 'start'
        options: [
          name: 'array'
          shortcut: 'a'
          type: 'array'
          one_of: ['1', '2']
        ]
      ]
      params.parse(['start', '-a', '1', '-a', '2']).should.eql
        command: 'start'
        array: ['1','2']
      params.stringify 
        command: 'start'
        array: ['1','2']
      .should.eql ['start', '--array', '1,2']
        
    it 'dont match elements in an array', ->
      params = parameters commands: [
        name: 'start'
        options: [
          name: 'array'
          shortcut: 'a'
          type: 'array'
          one_of: ['1', '3']
        ]
      ]
      try
        params.parse(['start', '-a', '1', '-a', '2'])
        throw Error 'Invalid'
      catch e then e.message.should.eql 'Invalid value "2" for option "array"'
      try
        params.stringify command: 'start', array: ['1','2']
        throw Error 'Invalid'
      catch e then e.message.should.eql 'Invalid value "2" for option "array"'
      
