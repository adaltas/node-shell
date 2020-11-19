
require('should')
require('..')({
  main: 'input' 
})
.parse([])
.should.eql({
  input: []
})
