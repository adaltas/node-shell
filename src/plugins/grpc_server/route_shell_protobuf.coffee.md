
# Route Shell Protobuf

Print the Protocol Buffer definition.

## Dependencies

    protobuf = require 'protobufjs'
    path = require 'path'
    fs = require 'fs'

## Source code

    module.exports = ({argv, params, config, error, writer}) ->
      proto_path = path.resolve __dirname, './shell.proto'
      switch params.format
        when 'json'
          protobuf.load proto_path, (err, root) ->
            return reject err if err
            writer.write JSON.stringify root.toJSON(), null, 2
            writer.end()
        when 'proto'
          fs.readFile proto_path, (err, data) ->
            return reject err if err
            writer.write data
            writer.end()
        else
          throw Error "Invalid Format"
      
