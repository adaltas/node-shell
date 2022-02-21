
// Dependencies
import proto from '@shell-js/grpc_proto';

// let grpc;
// try {
//   grpc = require('grpc');
// } catch (error) {
//   grpc = require('@grpc/grpc-js');
// }
import grpc from '@grpc/grpc-js';

export default function(config = {}) {
  if (config.address == null) {
    config.address = '127.0.0.1';
  }
  if (config.port == null) {
    config.port = 50051;
  }
  // Load the definition
  const packageDefinition = proto.loadSync();
  const shell_proto = grpc.loadPackageDefinition(packageDefinition).shell;
  // Instantiate the client
  const endpoint = `${config.address}:${config.port}`;
  const client = new shell_proto.Shell(endpoint, grpc.credentials.createInsecure());
  for (const name in shell_proto.Shell.service) {
    const service = shell_proto.Shell.service[name];
    // Response stream return a readable stream
    // Otherwise, convert the callback approach to a promise
    if (service.responseStream !== true) {
      client[name] = (function(handler) {
        return function() {
          const args = arguments;
          return new Promise((resolve, reject) => {
            return handler.call(this, ...args, function(err, response) {
              if (err) {
                return reject(err);
              } else {
                return resolve(response);
              }
            });
          });
        };
      })(client[name]);
    }
  }
  return client;
};
