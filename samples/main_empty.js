
require('should')
const shell = require('./packages/shell')

shell({
  main: 'input' 
})
.parse([])
.should.eql({
  input: []
})
