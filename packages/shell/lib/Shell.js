
// Shell.js Core object

// Dependencies
const path = require('path');
const stream = require('stream');
const load = require('./utils/load');
const utils = require('./utils');
const {clone, merge, is_object_literal} = require('mixme');

// Internal types
const types = ['string', 'boolean', 'integer', 'array'];

const registry = [];

const register = function(hook) {
  return registry.push(hook);
};

const Shell = function(config) {
  this.registry = [];
  this.config = {};
  this.init();
  this.collision = {};
  config = clone(config || {});
  this.config = config;
  this.confx().set(this.config);
  return this;
};

Shell.prototype.init = (function() {});

Shell.prototype.register = function(hook) {
  if (!is_object_literal(hook)) {
    throw utils.error(['Invalid Hook Registration:', 'hooks must consist of keys representing the hook names', 'associated with function implementing the hook,', `got ${hook}`]);
  }
  this.registry.push(hook);
  return this;
};

Shell.prototype.hook = function() {
  let args, handler, name, hooks;
  switch (arguments.length) {
    case 3:
      [name, args, handler] = arguments;
      break;
    case 4:
      [name, args, hooks, handler] = arguments;
      break;
    default:
      throw utils.error(['Invalid Hook Argument:', 'function hook expect 3 or 4 arguments', 'name, args, hooks? and handler,', `got ${arguments.length} arguments`]);
  }
  if (typeof hooks === 'function') {
    hooks = [hooks];
  }
  for (const hook of registry) {
    if (hook[name]) {
      handler = hook.call(this, args, handler);
    }
  }
  for (const hook of this.registry) {
    if (hook[name]) {
      handler = hook[name].call(this, args, handler);
    }
  }
  if (hooks) {
    for (const hook of hooks) {
      handler = hook.call(this, args, handler);
    }
  }
  return handler.call(this, args);
};

/*
`load(module)`

* `module`   
  Name of the module to load, require
Load and return a module, use `require.main.require` by default but can be
overwritten by the `load` options passed in the configuration.
*/
Shell.prototype.load = function(module) {
  if (typeof module !== 'string') {
    throw utils.error(['Invalid Load Argument:', 'load is expecting string,', `got ${JSON.stringify(module)}`].join(' '));
  }
  if (this.config.load) {
    if (typeof this.config.load === 'string') {
      return load(this.config.load)(module);
    } else {
      return this.config.load(module);
    }
  } else {
    return load(module);
  }
};

module.exports = Shell;
