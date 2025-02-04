// Plugin "grpc"

// Dependencies
import { Transform } from "node:stream";
import { utils } from "shell";
import { mutate } from "mixme";
import grpc from "@grpc/grpc-js";
import proto from "@shell-js/grpc_proto";

const passthrough = function () {
  return new Transform({
    objectMode: true,
    transform: function (chunk, encoding, callback) {
      chunk = {
        data: chunk,
      };
      return callback(null, chunk);
    },
  });
};

const get_handlers = function () {
  return {
    ping: function (call, callback) {
      return callback(null, {
        message: call.request.name,
      });
    },
    config: function (call, callback) {
      const config = this.config(call.request.command).get();
      return callback(null, {
        config: config,
      });
    },
    run: function (call) {
      const context = {
        argv: call.request.argv,
        is_grpc: true,
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
    },
  };
};

const grpc_start = function () {
  if (this._server) {
    throw utils.error("GRPC Server Already Started");
  }
  const appconfig = this.config().get();
  // Load the definition
  const packageDefinition = proto.loadSync();
  const shell_definition = grpc.loadPackageDefinition(packageDefinition).shell;
  // Instantiate the server
  const server = new grpc.Server();
  const handlers = get_handlers(shell_definition);
  for (const name in handlers) {
    const handler = handlers[name];
    handlers[name] = handler.bind(this);
  }
  server.addService(shell_definition.Shell.service, handlers);
  const endpoint = `${appconfig.grpc.address}:${appconfig.grpc.port}`;
  return new Promise((resolve, reject) => {
    server.bindAsync(
      endpoint,
      grpc.ServerCredentials.createInsecure(),
      (err, port) => {
        if (err) {
          return reject(err);
        } else {
          this._server = server;
          return resolve(port);
        }
      },
    );
  });
};

const grpc_stop = function () {
  return new Promise((resolve, reject) => {
    if (!this.grpc_started()) {
      return resolve(false);
    }
    return this._server.tryShutdown((err) => {
      if (err) {
        return reject(err);
      } else {
        this._server = null;
        return resolve(true);
      }
    });
  });
};

const grpc_started = function () {
  return !!this._server;
};

export default {
  name: "shell/grpc_server",
  hooks: {
    "shell:init": function ({ shell }) {
      shell.grpc_start = grpc_start.bind(shell);
      shell.grpc_started = grpc_started.bind(shell);
      shell.grpc_stop = grpc_stop.bind(shell);
    },
    "shell:config:set": [
      {
        after: "shell/plugins/router",
        handler: function ({ config, command }, handler) {
          if (command.length) {
            return handler;
          }
          if (config.grpc == null) {
            config.grpc = {};
          }
          if (config.grpc.address == null) {
            config.grpc.address = "127.0.0.1";
          }
          if (config.grpc.port == null) {
            config.grpc.port = 61234;
          }
          if (config.grpc.command_protobuf == null) {
            config.grpc.command_protobuf = false;
          }
          return handler;
        },
      },
      {
        handler: function ({ config, command }, handler) {
          if (command.length) {
            return handler;
          }
          if (!config.grpc.command_protobuf) {
            return handler;
          }
          mutate(config, {
            commands: {
              shell: {
                commands: {
                  protobuf: {
                    options: {
                      format: {
                        enum: ["json", "proto"],
                        default: "proto",
                      },
                    },
                    handler: "@shell-js/grpc_server/routes/shell_protobuf",
                  },
                },
              },
            },
          });
          return handler;
        },
      },
    ],
  },
};
