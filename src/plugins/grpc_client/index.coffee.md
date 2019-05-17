
    # Dependencies
    client = require('./client')()
    
    call = client.run argv: process.argv.slice 2
    call.on 'data', ({data})->
      process.stdout.write data
    call.on 'end', ->
      process.stdout.write 'end'
