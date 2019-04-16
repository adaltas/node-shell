
{Parameters} = require './Parameters'

    Parameters = require '../Parameters'
    error = require '../utils/error'
    {clone, is_object_literal, merge, mutate} = require 'mixme'
    
    commands_builder = (pcommand) ->
      builder = (command) =>
        ctx = @
        command = [command] if typeof command is 'string'
        command = [...pcommand, ...command]
        lconfig = @config
        for name in command
          # A new command doesn't have a config registered yet
          lconfig.commands[name] ?= {}
          lconfig = lconfig.commands[name]
        commands: commands_builder.call @, command
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
          lconfig = ctx.config
          for name in command
            # A new command doesn't have a config registered yet
            # lconfig.commands[name] ?= {}
            lconfig = lconfig.commands[name]
          mutate lconfig, values
          ctx.hook 'configure_commands_set',
            config: lconfig
            command: command
            values: values
          , ({config, command, values}) =>
            config.name = name
            # config.options ?= {}
            for k, v of config.options
              @options(k).set v
            for k, v of config.commands
              @commands(k).set v
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
          option = config.options[name] = merge config.options[name], values
          # Normalize option
          option.name = name
          option.type ?= 'string'
          throw error [
            'Invalid Option Configuration:'
            "supported options types are #{JSON.stringify types},"
            "got #{JSON.stringify option.type}"
            "for option #{JSON.stringify name}"
            "in command #{JSON.stringify config.command.join ' '}" if Array.isArray config.command
          ] unless option.type in types
          config.shortcuts[option.shortcut] = option.name if option.shortcut
          option.one_of = [option.one_of] if typeof option.one_of is 'string'
          throw error [
            'Invalid Option Configuration:'
            'option property "one_of" must be a string or an array,'
            "got #{option.one_of}"
          ] if option.one_of and not Array.isArray option.one_of
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
          @hook 'configure_app_set', config: @config, =>
            @config.options ?= {}
            for k, v of @config.options
              parent.options(k).set v
            for k, v of @config.commands
              parent.commands(k).set v
        parent.get = =>
          return @config
        parent.options = options_builder.call @, @config
        parent.commands = commands_builder.call @, @config
        parent.show = ->
          return @config
        parent
    )(Parameters::configure)
    

## Internal types

    types = ['string', 'boolean', 'integer', 'array']
