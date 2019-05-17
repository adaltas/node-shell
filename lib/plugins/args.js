// Generated by CoffeeScript 2.4.1
  // ## Plugin "args"

  // Dependencies
var Parameters, clone, error, is_object_literal, merge, set_default,
  indexOf = [].indexOf;

error = require('../utils/error');

({clone, is_object_literal, merge} = require('mixme'));

// Parameters & plugins
Parameters = require('../Parameters');

// ## Method `parse([arguments])`

// Convert an arguments list to a parameters object.

// * `arguments`: `[string] | process` The arguments to parse into parameters, accept the [Node.js process](https://nodejs.org/api/process.html) instance or an [argument list](https://nodejs.org/api/process.html#process_process_argv) provided as an array or a string, optional.
// * `options`: `object` Options used to alter the behavior of the `compile` method.
//   * `extended`: `boolean` The value `true` indicates that the parameters are returned in extended format, default to the configuration `extended` value which is `false` by default.
// * Returns: `object | [object]` The extracted parameters, a literal object in default flatten mode or an array in extended mode.
Parameters.prototype.parse = function(argv = process, options = {}) {
  var appconfig, command_params, full_params, i, index, k, len, params, parse, v;
  appconfig = this.confx().get();
  if (options.extended == null) {
    options.extended = appconfig.extended;
  }
  index = 0;
  // Remove node and script argv elements
  if (argv === process) {
    index = 2;
    argv = argv.argv;
  } else if (!Array.isArray(argv)) {
    throw error(['Invalid Arguments:', 'parse require arguments or process as first argument,', `got ${JSON.stringify(process)}`]);
  }
  // Extracted parameters
  full_params = [];
  parse = function(config, command) {
    var _, err, helping, i, key, leftover, len, main, option, params, ref, ref1, ref2, shortcut, type, value, values;
    full_params.push(params = {});
    if (command != null) {
      // Add command name provided by parent
      params[appconfig.command] = command;
    }
    // Read options
    while (true) {
      if (argv.length === index || argv[index][0] !== '-') {
        break;
      }
      key = argv[index++];
      shortcut = key[1] !== '-';
      key = key.substring((shortcut ? 1 : 2), key.length);
      if (shortcut) {
        shortcut = key;
      }
      if (shortcut) {
        key = config.shortcuts[shortcut];
      }
      option = (ref = config.options) != null ? ref[key] : void 0;
      if (!shortcut && config.strict && !option) {
        err = error(['Invalid Argument:', `the argument ${(shortcut ? "-" : "--")}${key} is not a valid option`]);
        err.command = full_params.slice(1).map(function(params) {
          return params[appconfig.command];
        });
        throw err;
      }
      if (shortcut && !option) {
        throw error(['Invalid Shortcut Argument:', `the "-${shortcut}" argument is not a valid option`, Array.isArray(config.command) ? `in command "${config.command.join(' ')}"` : void 0]);
      }
      // Auto discovery
      if (!option) {
        type = argv[index] && argv[index][0] !== '-' ? 'string' : 'boolean';
        option = {
          name: key,
          type: type
        };
      }
      switch (option.type) {
        case 'boolean':
          params[key] = true;
          break;
        case 'string':
          value = argv[index++];
          if (!((value != null) && value[0] !== '-')) {
            throw error(['Invalid Option:', `no value found for option ${JSON.stringify(key)}`]);
          }
          params[key] = value;
          break;
        case 'integer':
          value = argv[index++];
          if (!((value != null) && value[0] !== '-')) {
            throw error(['Invalid Option:', `no value found for option ${JSON.stringify(key)}`]);
          }
          params[key] = parseInt(value, 10);
          break;
        case 'array':
          value = argv[index++];
          if (!((value != null) && value[0] !== '-')) {
            throw error(['Invalid Option:', `no value found for option ${JSON.stringify(key)}`]);
          }
          if (params[key] == null) {
            params[key] = [];
          }
          params[key].push(...value.split(','));
      }
    }
    // Check if help is requested
    // TODO: this doesnt seem right, also, the test in help.parse seems wrong as well
    helping = false;
    ref1 = config.options;
    for (_ in ref1) {
      option = ref1[_];
      if (option.help !== true) {
        continue;
      }
      if (params[option.name]) {
        helping = true;
      }
    }
    if (helping) {
      return params;
    }
    ref2 = config.options;
    // Check against required options
    for (_ in ref2) {
      option = ref2[_];
      if (option.required) {
        if (params[option.name] == null) {
          throw error(['Required Option Argument:', `the "${option.name}" option must be provided`]);
        }
      }
      if (option.one_of) {
        values = params[option.name];
        if (!option.required && values !== void 0) {
          if (!Array.isArray(values)) {
            values = [values];
          }
          for (i = 0, len = values.length; i < len; i++) {
            value = values[i];
            if (indexOf.call(option.one_of, value) < 0) {
              throw error(['Invalid Argument Value:', `the value of option "${option.name}"`, `must be one of ${JSON.stringify(option.one_of)},`, `got ${JSON.stringify(value)}`]);
            }
          }
        }
      }
    }
    // We still have some argument to parse
    if (argv.length !== index) {
      // Store the full command in the return array
      leftover = argv.slice(index);
      if (config.main) {
        params[config.main.name] = leftover;
      } else {
        command = argv[index++];
        if (!config.commands[command]) {
          // Validate the command
          throw error(['Invalid Argument:', `fail to interpret all arguments "${leftover.join(' ')}"`]);
        }
        // Parse child configuration
        parse(config.commands[command], command);
      }
    }
    // NOTE: legacy versions used to inject an help command
    // when parsing arguments which doesnt hit a sub command
    // See the associated tests in "help/parse.coffee"
    // Happens with global options without a command
    // if Object.keys(config.commands).length and not command
    //   params[appconfig.command] = 'help'
    // Check against required main
    main = config.main;
    if (main && main.required) {
      if (params[main.name] == null) {
        throw error(['Required Main Argument:', `no suitable arguments for ${JSON.stringify(main.name)}`]);
      }
    }
    return params;
  };
  // Start the parser
  parse(appconfig, null);
  if (!options.extended) {
    params = {};
    if (Object.keys(appconfig.commands).length) {
      params[appconfig.command] = [];
    }
    for (i = 0, len = full_params.length; i < len; i++) {
      command_params = full_params[i];
      for (k in command_params) {
        v = command_params[k];
        if (k === appconfig.command) {
          params[k].push(v);
        } else {
          params[k] = v;
        }
      }
    }
  } else {
    params = full_params;
  }
  // Enrich params with default values
  set_default(appconfig, params);
  return params;
};

// ## Method `compile(command, [options])`

// Convert a parameters object to an arguments array.

// * `params`: `object` The parameter object to be converted into an array of arguments, optional.
// * `options`: `object` Options used to alter the behavior of the `compile` method.
//   * `extended`: `boolean` The value `true` indicates that the parameters are provided in extended format, default to the configuration `extended` value which is `false` by default.
//   * `script`: `string` The JavaScript file being executed by the engine, when present, the engine and the script names will prepend the returned arguments, optional, default is false.
// * Returns: `array` The command line arguments.
Parameters.prototype.compile = function(params, options = {}) {
  var appconfig, argv, compile, keys;
  argv = options.script ? [process.execPath, options.script] : [];
  appconfig = this.confx().get();
  if (options.extended == null) {
    options.extended = appconfig.extended;
  }
  if (!is_object_literal(options)) {
    throw error(['Invalid Compile Arguments:', '2nd argument option must be an object,', `got ${JSON.stringify(options)}`]);
  }
  keys = {};
  // In extended mode, the params array will be truncated
  // params = merge params unless extended
  set_default(appconfig, params);
  if (typeof params[appconfig.command] === 'string') {
    // Convert command parameter to a 1 element array if provided as a string
    params[appconfig.command] = [params[appconfig.command]];
  }
  // Compile
  compile = function(config, lparams) {
    var _, command, has_child_commands, i, key, len, option, ref, results, val, value;
    ref = config.options;
    for (_ in ref) {
      option = ref[_];
      key = option.name;
      keys[key] = true;
      value = lparams[key];
      if (option.required && (value == null)) {
        // Validate required value
        throw error(['Required Option Parameter:', `the "${key}" option must be provided`]);
      }
      // Validate value against option "one_of"
      if ((value != null) && option.one_of) {
        if (!Array.isArray(value)) {
          value = [value];
        }
        for (i = 0, len = value.length; i < len; i++) {
          val = value[i];
          if (indexOf.call(option.one_of, val) < 0) {
            throw error(['Invalid Parameter Value:', `the value of option "${option.name}"`, `must be one of ${JSON.stringify(option.one_of)},`, `got ${JSON.stringify(val)}`]);
          }
        }
      }
      // Serialize
      if (value) {
        switch (option.type) {
          case 'boolean':
            argv.push(`--${key}`);
            break;
          case 'string':
          case 'integer':
            argv.push(`--${key}`);
            argv.push(`${value}`);
            break;
          case 'array':
            argv.push(`--${key}`);
            argv.push(`${value.join(',')}`);
        }
      }
    }
    if (config.main) {
      value = lparams[config.main.name];
      if (config.main.required && (value == null)) {
        throw error(['Required Main Parameter:', `no suitable arguments for ${JSON.stringify(config.main.name)}`]);
      }
      if (value != null) {
        if (!Array.isArray(value)) {
          throw error(['Invalid Parameter Type:', `expect main to be an array, got ${JSON.stringify(value)}`]);
        }
        keys[config.main.name] = value;
        argv = argv.concat(value);
      }
    }
    // Recursive
    has_child_commands = options.extended ? params.length : Object.keys(config.commands).length;
    if (has_child_commands) {
      command = options.extended ? params[0][appconfig.command] : params[appconfig.command].shift();
      if (!config.commands[command]) {
        throw error(['Invalid Command Parameter:', `command ${JSON.stringify(command)} is not registed,`, `expect one of ${JSON.stringify(Object.keys(config.commands).sort())}`, Array.isArray(config.command) ? `in command ${JSON.stringify(config.command.join(' '))}` : void 0]);
      }
      argv.push(command);
      keys[appconfig.command] = command;
      // Compile child configuration
      compile(config.commands[command], options.extended ? params.shift() : lparams);
    }
    if (options.extended || !has_child_commands) {
// Handle params not defined in the configuration
// Note, they are always pushed to the end and associated with the deepest child
      results = [];
      for (key in lparams) {
        value = lparams[key];
        if (keys[key]) {
          continue;
        }
        if (appconfig.strict) {
          throw Error(['Invalid Parameter:', `the property --${key} is not a registered argument`].join(' '));
        }
        if (typeof value === 'boolean') {
          if (value) {
            results.push(argv.push(`--${key}`));
          } else {
            results.push(void 0);
          }
        } else if (typeof value === 'undefined' || value === null) {

        } else {
          // nothing
          argv.push(`--${key}`);
          results.push(argv.push(`${value}`));
        }
      }
      return results;
    }
  };
  compile(appconfig, options.extended ? params.shift() : params);
  return argv;
};

// ## Utils

// Given a configuration, apply default values to the parameters
set_default = function(config, params, tempparams = null) {
  var _, command, name, option, ref;
  if (tempparams == null) {
    tempparams = merge(params);
  }
  if (Object.keys(config.commands).length) {
    command = tempparams[config.command];
    if (Array.isArray(command)) {
      command = tempparams[config.command].shift();
    }
    // We are not validating if the command is valid, it may not be set if help option is present
    // throw Error "Invalid Command: \"#{command}\"" unless config.commands[command]
    if (config.commands[command]) {
      params = set_default(config.commands[command], params, tempparams);
    }
  }
  ref = config.options;
  for (_ in ref) {
    option = ref[_];
    if (option.default != null) {
      if (params[name = option.name] == null) {
        params[name] = option.default;
      }
    }
  }
  return params;
};