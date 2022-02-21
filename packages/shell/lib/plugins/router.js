
// Plugin "router"

// Dependencies
const path = require('path');
const stream = require('stream');
const utils = require('../utils');
const {clone, merge, is_object_literal} = require('mixme');

// Shell.js & plugins
const Shell = require('../Shell');
require('../plugins/config');

Shell.prototype.init = (function(parent) {
  return function() {
    this.register({
      configure_set: function({config, command}, handler) {
        if (command.length) {
          return handler;
        }
        if (config.router == null) {
          config.router = {};
        }
        if (config.router.handler == null) {
          config.router.handler = path.resolve(__dirname, '../routes/help');
        }
        if (config.router.promise == null) {
          config.router.promise = false;
        }
        if (config.router.stdin == null) {
          config.router.stdin = process.stdin;
        }
        if (config.router.stdout == null) {
          config.router.stdout = process.stdout;
        }
        if (config.router.stdout_end == null) {
          config.router.stdout_end = false;
        }
        if (config.router.stderr == null) {
          config.router.stderr = process.stderr;
        }
        if (config.router.stderr_end == null) {
          config.router.stderr_end = false;
        }
        if (! config.router.stdin instanceof stream.Readable) {
          throw utils.error(["Invalid Configuration Property:", "router.stdin must be an instance of stream.Readable,", `got ${JSON.stringify(config.router.stdin)}`]);
        }
        if (! config.router.stdout instanceof stream.Writable) {
          throw utils.error(["Invalid Configuration Property:", "router.stdout must be an instance of stream.Writable,", `got ${JSON.stringify(config.router.stdout)}`]);
        }
        if (! config.router.stderr instanceof stream.Writable) {
          throw utils.error(["Invalid Configuration Property:", "router.stderr must be an instance of stream.Writable,", `got ${JSON.stringify(config.router.stderr)}`]);
        }
        return handler;
      }
    });
    return parent.call(this, ...arguments);
  };
})(Shell.prototype.init);

Shell.prototype.init = (function(parent) {
  return function() {
    this.register({
      configure_set: function({config, command}, handler) {
        if (!config.handler) {
          return handler;
        }
        if (typeof config.handler !== 'function' && typeof config.handler !== 'string') {
          throw utils.error([
            'Invalid Route Configuration:',
            "accept string or function",
            !command.length
            ? "in application,"
            : `in command ${JSON.stringify(command.join(' '))},`,
            `got ${JSON.stringify(config.handler)}`
          ]);
        }
        return handler;
      }
    });
    return parent.call(this, ...arguments);
  };
})(Shell.prototype.init);


// ## Method `route(context, ...users_arguments)`

// * `cli_arguments`: `[string] | object | process` The arguments to parse into arguments, accept the [Node.js process](https://nodejs.org/api/process.html) instance, an [argument list](https://nodejs.org/api/process.html#process_process_argv) provided as an array of strings or the context object; optional, default to `process`.
// * `...users_arguments`: `any` Any arguments that will be passed to the executed function associated with a route.
// * Returns: `Promise<any>` Whatever the route function returns wrapped inside a promise.

// How to use the `route` method to execute code associated with a particular command.
Shell.prototype.route = function(context = {}, ...args) {
  // Normalize arguments
  if (Array.isArray(context)) {
    context = {
      argv: context
    };
  } else if (!is_object_literal(context)) {
    throw utils.error(['Invalid Router Arguments:', 'first argument must be a context object or the argv array,', `got ${JSON.stringify(context)}`]);
  }
  const appconfig = this.confx().get();
  const route_load = (handler) => {
    if (typeof handler === 'string') {
      return this.load(handler);
    } else if (typeof handler === 'function') {
      return handler;
    } else {
      throw utils.error(`Invalid Handler: expect a string or a function, got ${handler}`);
    }
  };
  const route_call = (handler, command, params, err, args) => {
    const config = this.confx().get();
    context = {
      argv: process.argv.slice(2),
      command: command,
      error: err,
      params: params,
      args: args,
      stdin: config.router.stdin,
      stdout: config.router.stdout,
      stdout_end: config.router.stdout_end,
      stderr: config.router.stderr,
      stderr_end: config.router.stderr_end,
      ...context
    };
    return this.hook('router_call', context, (context) => {
      if (!config.router.promise) {
        return handler.call(this, context, ...args);
      }
      try {
        // Otherwise wrap result in a promise 
        const result = handler.call(this, context, ...args);
        if (result && typeof result.then === 'function') {
          return result;
        }
        return new Promise(function(resolve, reject) {
          return resolve(result);
        });
      } catch (error) {
        return new Promise(function(resolve, reject) {
          return reject(error);
        });
      }
    });
  };
  const route_error = (err, command) => {
    context.argv = command.length ? ['help', ...command] : ['--help'];
    const params = this.parse(context.argv);
    const handler = route_load(this.config.router.handler);
    return route_call(handler, command, params, err, args);
  };
  const route_from_config = (config, command, params) => {
    let err;
    let handler = config.handler;
    if (!handler) {
      // Provide an error message if leaf command without a handler
      if (!Object.keys(config.commands).length) { // Object.keys(config.commands).length or
        err = config.root ? utils.error(['Missing Application Handler:', 'a \"handler\" definition is required when no child command is defined']) : utils.error(['Missing Command Handler:', `a \"handler\" definition ${JSON.stringify(params[appconfig.command])} is required when no child command is defined`]);
      }
      // Convert argument to an help command
      context.argv = command.length ? ['help', ...command] : ['--help'];
      params = this.parse(context.argv);
      handler = this.config.router.handler;
    }
    handler = route_load(handler);
    return route_call(handler, command, params, err, args);
  };
  let params;
  try {
    // Read arguments
    params = this.parse(context.argv);
  } catch (error) {
    return route_error(error, error.command || []);
  }
  // Print help
  if (command = this.helping(params)) {
    // this seems wrong, must be the handler of the command
    const handler = this.load(appconfig.router.handler);
    return route_call(handler, command, params, undefined, args);
  } else {
    // Return undefined if not parsing command based arguments
    // Load a command route
    let command = params[appconfig.command];
    if (appconfig.extended) {
      // TODO: not tested yet, construct a commands array like in flatten mode when extended is activated
      // command = (for i in [0...params.length] then params[i][appconfig.command]) if appconfig.extended
      command = []
      for (const param in params){
        command.push[appconfig.command]
      }
    }
    const config = this.confx(command).get();
    return route_from_config(config, command || [], params);
  }
};
