'use strict';

var proto = require('@shell-js/grpc_proto');
var grpc = require('@grpc/grpc-js');

function _interopDefaultLegacy (e) { return e && typeof e === 'object' && 'default' in e ? e : { 'default': e }; }

var proto__default = /*#__PURE__*/_interopDefaultLegacy(proto);
var grpc__default = /*#__PURE__*/_interopDefaultLegacy(grpc);

function client(config = {}) {
  if (config.address == null) {
    config.address = '127.0.0.1';
  }
  if (config.port == null) {
    config.port = 50051;
  }
  // Load the definition
  const packageDefinition = proto__default["default"].loadSync();
  const shell_proto = grpc__default["default"].loadPackageDefinition(packageDefinition).shell;
  // Instantiate the client
  const endpoint = `${config.address}:${config.port}`;
  const client = new shell_proto.Shell(endpoint, grpc__default["default"].credentials.createInsecure());
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
}

const call = client().run({
  argv: process.argv.slice(2)
});

call.on('data', function({data}) {
  return process.stdout.write(data);
});

call.on('end', function() {
  return process.stdout.write('end');
});
