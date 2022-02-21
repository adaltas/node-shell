
// Route Shell Protobuf
// Print the Protocol Buffer definition.

// Dependencies
import fs from 'node:fs';
import protobuf from 'protobufjs';
import proto from '@shell-js/grpc_proto';

// ## Source code
export default function({argv, params, config, error, stdout, stdout_end}) {
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
