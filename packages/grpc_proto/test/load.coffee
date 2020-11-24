
protobuf = require '../src'

describe 'grpc_protobuf.load', ->
  
  it 'async', ->
    packageDefinition = await protobuf.load()
    packageDefinition.should.have.key 'shell.Shell'
      
  it 'sync', ->
    packageDefinition = protobuf.loadSync()
    packageDefinition.should.have.key 'shell.Shell'
