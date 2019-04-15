
{Parameters} = require './Parameters'

    Parameters = require '../Parameters'
    error = require '../utils/error'
    {clone, is_object_literal, merge, mutate} = require 'mixme'
    
    commands_builder = (pconfig) ->
      builder = (command) =>
        ctx = @
        command = [command] if typeof command is 'string'
        lconfig = pconfig
        for name in command
          lconfig = lconfig.commands[name]
        commands: commands_builder.call @, lconfig
        options: options_builder.call @, lconfig
        get: ->
          lconfig
        set: ->
          values = null
          if arguments.length is 2
            values = [arguments[0]]: arguments[1]
          else if arguments.length is 1
            values = arguments[0]
          else throw error [
            'Invalid Commands Set Arguments:'
            'expect 1 or 2 arguments, got 0'
          ]
          lconfig = pconfig
          for name in command
            # A new command doesn't have a config registered yet
            lconfig.commands[name] ?= {}
            lconfig = lconfig.commands[name]
          mutate lconfig, values
          ctx.hook 'configure_commands_set',
            config: lconfig
            command: command
            values: values
          , ({config, command, values}) ->
            config.name = name
          @
        remove: ->
          delete lconfig.options[command]
        show: ->
          lconfig
      builder
    
    options_builder = (config) ->
      builder = (name) ->
        get: (properties) ->
          properties = [properties] if typeof properties is 'string'
          if Array.isArray properties
            options = {}
            for property in properties
              options[property] = config.options[name][property]
            options
          else
            config.options[name]
        remove: (name) ->
          delete config.options[name]
        set: (property, value) ->
          config.options[name][property] = value
          @
      builder.__proto__ =
        list: ->
          Object.keys config.options
        get: (name) ->
          config.options[name]
      builder
    
    Parameters::configure = ( (parent) ->
      ->
        return parent.call @, arguments... if arguments.length
        parent.set = =>
          @hook 'configure_app_set', config: @config, (->)
        parent.get = =>
          return @config
        parent.options = options_builder.call @, @config
        parent.commands = commands_builder.call @, @config
        parent.show = ->
          return @config
        parent
    )(Parameters::configure)
