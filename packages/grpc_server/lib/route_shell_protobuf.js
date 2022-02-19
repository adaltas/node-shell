
// Route Shell Protobuf
// Print the Protocol Buffer definition.

// Dependencies
const protobuf = require('protobufjs');
const proto = require('@shell-js/grpc_proto');
const fs = require('fs');

// ## Source code
module.exports = function({argv, params, config, error, stdout, stdout_end}) {
  const proto_path = proto.resolve();
  switch (params.format) {
    case 'json':
      return protobuf.load(proto_path, function(err, root) {
        if (err) {
          return reject(err);
        }
        stdout.write(JSON.stringify(root.toJSON(), null, 2));
        if (stdout_end) {
          return stdout.end();
        }
      });
    case 'proto':
      return fs.readFile(proto_path, function(err, data) {
        if (err) {
          return reject(err);
        }
        stdout.write(data);
        if (stdout_end) {
          return stdout.end();
        }
      });
    default:
      // TODO: more explicit error message
      throw error(["Invalid Format"]);
  }
};
