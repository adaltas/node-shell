'use strict';

var fs = require('node:fs');
var protobuf = require('protobufjs');
var proto = require('@shell-js/grpc_proto');

// Route Shell Protobuf
// Print the Protocol Buffer definition.


// Source code
function shell_protobuf ({ params, error, stdout, stdout_end }) {
  const proto_path = proto.resolve();
  switch (params.format) {
    case "json":
      return protobuf.load(proto_path, function (err, root) {
        if (err) {
          throw err;
        }
        stdout.write(JSON.stringify(root.toJSON(), null, 2));
        if (stdout_end) {
          stdout.end();
        }
      });
    case "proto":
      return fs.readFile(proto_path, function (err, data) {
        if (err) {
          throw err;
        }
        stdout.write(data);
        if (stdout_end) {
          stdout.end();
        }
      });
    default:
      // TODO: more explicit error message
      throw error(["Invalid Format"]);
  }
}

module.exports = shell_protobuf;
