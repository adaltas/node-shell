// Generated by CoffeeScript 2.4.1
// ## Plugin "remote"

// Dependencies
var Parameters, Transform, error, get_handlers, grpc, mutate, path, protoLoader;

path = require('path');

// pad = require 'pad'
error = require('../../utils/error');

({mutate} = require('mixme'));

// grpc = require '@grpc/grpc-js'
grpc = require('grpc');

protoLoader = require('@grpc/proto-loader');

// Parameters & plugins
Parameters = require('../../Parameters');

require('../../plugins/config');

require('../../plugins/router');

({Transform} = require('stream'));

Parameters.prototype.init = (function(parent) {
  return function() {
    // Plugin configuration
    this.register({
      configure_set: function({config, command}, handler) {
        var base, base1, base2;
        if (command.length) {
          return handler;
        }
        if (config.remote == null) {
          config.remote = {};
        }
        if ((base = config.remote).address == null) {
          base.address = '0.0.0.0';
        }
        if ((base1 = config.remote).port == null) {
          base1.port = 50051;
        }
        if ((base2 = config.remote).command_protobuf == null) {
          base2.command_protobuf = false;
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
        if (!config.remote.command_protobuf) {
          return handler;
        }
        mutate(config, {
          commands: {
            'shell': {
              commands: {
                'protobuf': {
                  options: {
                    format: {
                      one_of: ['json', 'proto'],
                      default: 'proto'
                    }
                  },
                  route: path.resolve(__dirname, './route_shell_protobuf')
                }
              }
            }
          }
        });
        return handler;
      }
    });
    parent.call(this, ...arguments);
    // Register the "shell protobuf" command
    return this.register({
      router_call: function(context, handler) {
        var call;
        if (!this.server_started()) {
          return handler;
        }
        [call] = context.args;
        if (call.is_grpc) {
          if (call.readable) {
            context.reader = call;
          }
          if (call.writable) {
            context.writer = call;
            context.writer.write = (function(write) {
              return function(chunk, ...args) {
                chunk = {
                  data: chunk
                };
                return write.call(this, chunk, ...args);
              };
            })(context.writer.write);
          }
        }
        return handler;
      }
    });
  };
})(Parameters.prototype.init);

get_handlers = function(definition) {
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
      call.is_grpc = true;
      return this.route(call.request.argv, call);
    }
  };
};

Parameters.prototype.server_start = function(callback) {
  var appconfig, endpoint, handler, handlers, name, packageDefinition, promise, proto_path, ref, server, shell_definition;
  if ((ref = this._server) != null ? ref.started : void 0) {
    throw error('GRPC Server Already Started');
  }
  appconfig = this.confx().get();
  // Load the definition
  proto_path = path.resolve(__dirname, './shell.proto');
  packageDefinition = protoLoader.loadSync(proto_path, {
    keepCase: true,
    longs: String,
    enums: String,
    defaults: true,
    oneofs: true
  });
  shell_definition = grpc.loadPackageDefinition(packageDefinition).shell;
  // Instantiate the server
  server = new grpc.Server();
  handlers = get_handlers(shell_definition);
  for (name in handlers) {
    handler = handlers[name];
    handlers[name] = handler.bind(this);
  }
  server.addService(shell_definition.Shell.service, handlers);
  endpoint = `${appconfig.remote.address}:${appconfig.remote.port}`;
  promise = new Promise(function(resolve, reject) {
    return server.bindAsync(endpoint, grpc.ServerCredentials.createInsecure(), function(err, port) {
      if (err) {
        return reject(err);
      } else {
        return resolve(port);
      }
    });
  });
  server.start();
  this._server = server;
  return promise;
};

Parameters.prototype.server_stop = function() {
  var server;
  server = this._server;
  return new Promise(function(resolve, reject) {
    return server.tryShutdown(function(err) {
      // Note, as of june 2019,
      // grpc marks the server as started but not as stopped
      server.started = false;
      if (err) {
        return reject(err);
      } else {
        return resolve();
      }
    });
  });
};

Parameters.prototype.server_started = function() {
  var ref;
  return !!((ref = this._server) != null ? ref.started : void 0);
};