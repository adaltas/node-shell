'use strict';

var node_stream = require('node:stream');
var shell = require('shell');
var mixme = require('mixme');
var grpc = require('@grpc/grpc-js');
var proto = require('@shell-js/grpc_proto');

function _interopDefaultLegacy (e) { return e && typeof e === 'object' && 'default' in e ? e : { 'default': e }; }

var grpc__default = /*#__PURE__*/_interopDefaultLegacy(grpc);
var proto__default = /*#__PURE__*/_interopDefaultLegacy(proto);

// import 'shell/lib/plugins/config';
// import 'shell/lib/plugins/router';

shell.Shell.prototype.init = (function(parent) {
  return function() {
    // Plugin configuration
    this.register({
      configure_set: function({config, command}, handler) {
        if (command.length) {
          return handler;
        }
        if (config.grpc == null) {
          config.grpc = {};
        }
        if (config.grpc.address == null) {
          config.grpc.address = '127.0.0.1';
        }
        if (config.grpc.port == null) {
          config.grpc.port = 61234;
        }
        if (config.grpc.command_protobuf == null) {
          config.grpc.command_protobuf = false;
        }
        return handler;
      }
    });
    // Register the "shell protobuf" command
    this.register({
      configure_set: function({config, command}, handler) {
        if (command.length) {
          return handler;
        }
        if (!config.grpc.command_protobuf) {
          return handler;
        }
        mixme.mutate(config, {
          commands: {
            'shell': {
              commands: {
                'protobuf': {
                  options: {
                    format: {
                      enum: ['json', 'proto'],
                      default: 'proto'
                    }
                  },
                  handler: '@shell-js/grpc_server/routes/shell_protobuf'
                }
              }
            }
          }
        });
        return handler;
      }
    });
    return parent.call(this, ...arguments);
  };
})(shell.Shell.prototype.init);

const passthrough = function() {
  return new node_stream.Transform({
    objectMode: true,
    transform: function(chunk, encoding, callback) {
      chunk = {
        data: chunk
      };
      return callback(null, chunk);
    }
  });
};

const get_handlers = function(definition) {
  return {
    ping: function(call, callback) {
      return callback(null, {
        message: call.request.name
      });
    },
    config: function(call, callback) {
      var config;
      config = this.confx(call.request.command).get();
      return callback(null, {
        config: config
      });
    },
    run: function(call) {
      var context;
      context = {
        argv: call.request.argv,
        is_grpc: true
      };
      if (call.readable) {
        context.reader = call;
      }
      if (call.writable) {
        context.stdout = passthrough();
        context.stdout.pipe(call);
        context.stderr = passthrough();
        context.stderr.pipe(call);
      }
      return this.route(context);
    }
  };
};

shell.Shell.prototype.grpc_start = function(callback) {
  if (this._server && this._server.started) {
    throw shell.utils.error('GRPC Server Already Started');
  }
  const appconfig = this.confx().get();
  // Load the definition
  const packageDefinition = proto__default["default"].loadSync();
  const shell_definition = grpc__default["default"].loadPackageDefinition(packageDefinition).shell;
  // Instantiate the server
  const server = new grpc__default["default"].Server();
  const handlers = get_handlers();
  for (const name in handlers) {
    const handler = handlers[name];
    handlers[name] = handler.bind(this);
  }
  server.addService(shell_definition.Shell.service, handlers);
  const endpoint = `${appconfig.grpc.address}:${appconfig.grpc.port}`;
  const promise = new Promise(function(resolve, reject) {
    return server.bindAsync(endpoint, grpc__default["default"].ServerCredentials.createInsecure(), function(err, port) {
      server.start();
      if (err) {
        return reject(err);
      } else {
        return resolve(port);
      }
    });
  });
  this._server = server;
  return promise;
};

shell.Shell.prototype.grpc_stop = function() {
  // server = @_server
  return new Promise((resolve, reject) => {
    if (!this.grpc_started()) {
      return resolve(false);
    }
    return this._server.tryShutdown((err) => {
      // Note, as of june 2019,
      // grpc marks the server as started but not as stopped
      this._server.started = false;
      if (err) {
        return reject(err);
      } else {
        return resolve(true);
      }
    });
  });
};

shell.Shell.prototype.grpc_started = function() {
  var ref;
  return !!((ref = this._server) != null ? ref.started : void 0);
};
