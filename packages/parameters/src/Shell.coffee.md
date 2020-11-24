
# Shell.js Core object

    registry = []
    register = (hook) ->
      registry.push hook

    Shell = (config) ->
      @registry = []
      @config = {}
      @init()
      @collision = {}
      config = clone config or {}
      @config = config
      @confx().set @config
      @
    
    Shell::init = (->)
  
    Shell::register = (hook) ->
      throw utils.error [
        'Invalid Hook Registration:'
        'hooks must consist of keys representing the hook names'
        'associated with function implementing the hook,'
        "got #{hook}"
      ] unless is_object_literal hook
      @registry.push hook
      @
  
    Shell::hook = ->
      switch arguments.length
        when 3 then [name, args, handler] = arguments
        when 4 then [name, args, hooks, handler] = arguments
        else throw utils.error [
          'Invalid Hook Argument:'
          'function hook expect 3 or 4 arguments'
          'name, args, hooks? and handler,'
          "got #{arguments.length} arguments"
        ]
      hooks = [hooks] if typeof hooks is 'function'
      for hook in registry
        handler = hook.call @, args, handler if hook[name]
      for hook in @registry
        handler = hook[name].call @, args, handler if hook[name]
      if hooks then for hook in hooks
        handler = hook.call @, args, handler
      handler.call @, args

## `load(module)`

* `module`   
  Name of the module to load, required.

Load and return a module, use `require.main.require` by default but can be
overwritten by the `load` options passed in the configuration.

    Shell::load = (module) ->
      throw utils.error [
        'Invalid Load Argument:'
        'load is expecting string,'
        "got #{JSON.stringify module}"
      ].join ' ' unless typeof module is 'string'
      if @config.load
        if typeof @config.load is 'string'
          load(@config.load)(module)
        else
          @config.load module
      else
        load module

## Export
        
    module.exports = Shell

## Dependencies

    path = require 'path'
    stream = require 'stream'
    load = require './utils/load'
    utils = require './utils'
    {clone, merge, is_object_literal} = require 'mixme'

## Internal types

    types = ['string', 'boolean', 'integer', 'array']
