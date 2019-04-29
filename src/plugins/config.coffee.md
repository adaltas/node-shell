
{Parameters} = require './Parameters'

    Parameters = require '../Parameters'
    error = require '../utils/error'
    {clone, is_object_literal, merge, mutate} = require 'mixme'
    
    commands_builder = (pcommand) ->
      ctx = @
      builder = (command) =>
        command = [command] if typeof command is 'string'
        command = [...pcommand, ...command]
        lconfig = @config
        for name in command
          # A new command doesn't have a config registered yet
          lconfig.commands[name] ?= {}
          lconfig = lconfig.commands[name]
        commands: commands_builder.call @, command
        main: builder_main.call @, command
        options: options_builder.call @, command
        get: ->
          source = ctx.config
          for name in command
            throw Error 'Invalid Command' unless source.commands[name]
            # A new command doesn't have a config registered yet
            source.commands[name] ?= {}
            source = source.commands[name]
          config = clone source
          if command.length
            config.command = command
          for name, _ of config.commands
            config.commands[name] = @commands(name).get()
          config.options = @options.show()
          config.shortcuts = {}
          for name, option of config.options
            config.shortcuts[option.shortcut] = option.name if option.shortcut
          config.main = @main.get() if config.main?
          config
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
          hook = unless command.length
          then 'configure_app_set'
          else 'configure_commands_set'
          ctx.hook hook,
            config: lconfig
            command: command
            values: values
          , ({config, command, values}) =>
            unless command.length
              config.extended ?= false
              throw error [
                'Invalid Configuration:'
                'extended must be a boolean,'
                "got #{JSON.stringify config.extended}"
              ] unless typeof config.extended is 'boolean'
              config.root = true
              config.name ?= 'myapp'
              config.command ?= 'command' if Object.keys(config.commands).length
            else
              throw error [
                'Incoherent Command Name:'
                "key #{JSON.stringify name} is not equal with name #{JSON.stringify config.name}"
              ] if config.name and config.name isnt command.slice(-1)[0]
              throw error [
                'Invalid Command Configuration:'
                'command property can only be declared at the application level,'
                "got command #{JSON.stringify config.command}"
              ] if config.command?
              # config.command = command
              throw error [
                'Invalid Command Configuration:'
                'extended property cannot be declared inside a command'
              ] if config.extended?
            config.name = name
            config.commands ?= {}
            config.options ?= {}
            config.shortcuts ?= {}
            config.strict ?= ( (config) ->
              strict = config.strict or false
              for name in command
                config = config.commands[name]
                strict = config.strict if config.strict?
              strict
            )(ctx.confx().raw())
            # config.options ?= {}
            for k, v of config.options
              @options(k).set v
            for k, v of config.commands
              @commands(k).set v
            @main.set config.main
          @
        remove: ->
          delete lconfig.options[command]
        show: (properties) ->
          config = clone lconfig
          properties = [properties] if typeof properties is 'string'
          return config unless Array.isArray properties
          filtered_config = {}
          for property in properties
            continue unless config[property]?
            filtered_config[property] = config[property]
          filtered_config
      # builder.get = ->
      #   source = ctx.confx(pcommand).raw()
      #   config = {}
      #   for name, _ of source.commands
      #     config[name] = builder(name).get()
      #   config
      builder
  
  
    builder_main = (commands) ->
      ctx = @
      builder =
        get: ->
          config = ctx.confx(commands).raw()
          clone config.main
        set: (value) ->
          config = ctx.confx(commands).raw()
          # Do nothing if value is undefined
          return builder if value is undefined
          # Unset the property if null
          if value is null
            config.main = undefined
            return builder
          value = name: value if typeof value is 'string'
          config.main = value
          builder
      builder
    
    options_builder = (commands) ->
      ctx = @
      builder = (name) ->
        get: (properties) ->
          # Initialize options with cascaded options
          options = builder.show()
          option = options[name]
          properties = [properties] if typeof properties is 'string'
          return option unless Array.isArray properties
          copy = {}
          for property in properties
            copy[property] = option[property]
          copy
        remove: (name) ->
          config = ctx.confx(commands).raw()
          delete config.options[name]
        set: ->
          config = ctx.confx(commands).raw()
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
          unless ctx.config.extended
            if not option.disabled and commands.length
              # Compare the current command with the options previously registered
              collide = ctx.collision[name] and ctx.collision[name].filter((cmd, i) ->
                commands[i] isnt cmd
              ).length is 0
              throw error [
                'Invalid Option Configuration:'
                "option #{JSON.stringify name}"
                "in command #{JSON.stringify commands.join ' '}"
                "collide with the one in #{if ctx.collision[name].length is 0 then 'application' else JSON.stringify ctx.collision[name].join ' '},"
                "change its name or use the extended property"
              ] if collide
            # Associate options with their declared command
            ctx.collision[name] = commands
          # Normalize option
          option.name = name
          option.type ?= 'string'
          throw error [
            'Invalid Option Configuration:'
            "supported options types are #{JSON.stringify types},"
            "got #{JSON.stringify option.type}"
            "for option #{JSON.stringify name}"
            "in command #{JSON.stringify commands.join ' '}" if commands.length
          ] unless option.type in types
          # config.shortcuts[option.shortcut] = option.name if option.shortcut and not option.disabled
          option.one_of = [option.one_of] if typeof option.one_of is 'string'
          throw error [
            'Invalid Option Configuration:'
            'option property "one_of" must be a string or an array,'
            "got #{option.one_of}"
          ] if option.one_of and not Array.isArray option.one_of
          @
      builder.__proto__ =
        get_cascaded: ->
          options = {}
          config = ctx.confx().raw()
          for command, i in commands
            for name, option of config.options
              continue unless option.cascade
              cascade_is_number = typeof option.cascade is 'number'
              continue if cascade_is_number and commands.length > option.cascade + i
              options[name] = clone option
            config = config.commands[command]
          options
        show: ->
          # Initialize options with cascaded options
          options = builder.get_cascaded()
          for name, option of options
            option.transient = true
          # Get app/command configuration
          config = ctx.confx(commands).raw()
          # Merge cascaded with local options
          options = merge options, config.options
          for name, option of options
            delete options[name] if option.disabled
          options
        list: ->
          Object.keys(builder.show()).sort()
      builder
    
    Parameters::confx = (command=[]) ->
      ctx = @
      command = [command] if typeof command is 'string'
      # command = [...pcommand, ...command]
      lconfig = @config
      for name in command
        # A new command doesn't have a config registered yet
        lconfig.commands[name] ?= {}
        lconfig = lconfig.commands[name]
      commands: commands_builder.call @, command
      main: builder_main.call @, command
      options: options_builder.call @, command
      get: ->
        source = ctx.config
        for name in command
          throw Error 'Invalid Command' unless source.commands[name]
          # A new command doesn't have a config registered yet
          source.commands[name] ?= {}
          source = source.commands[name]
        config = clone source
        if command.length
          config.command = command
        for name, _ of config.commands
          config.commands[name] = @commands(name).get()
        config.options = @options.show()
        config.shortcuts = {}
        for name, option of config.options
          config.shortcuts[option.shortcut] = option.name if option.shortcut
        config.main = @main.get() if config.main?
        config
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
        hook = unless command.length
        then 'configure_app_set'
        else 'configure_commands_set'
        ctx.hook hook,
          config: lconfig
          command: command
          values: values
        , ({config, command, values}) =>
          # config.name = name
          unless command.length
            config.extended ?= false
            throw error [
              'Invalid Configuration:'
              'extended must be a boolean,'
              "got #{JSON.stringify config.extended}"
            ] unless typeof config.extended is 'boolean'
            config.root = true
            config.name ?= 'myapp'
            config.command ?= 'command' if Object.keys(config.commands).length
          else
            throw error [
              'Incoherent Command Name:'
              "key #{JSON.stringify name} is not equal with name #{JSON.stringify config.name}"
            ] if config.name and config.name isnt command.slice(-1)[0]
            throw error [
              'Invalid Command Configuration:'
              'command property can only be declared at the application level,'
              "got command #{JSON.stringify config.command}"
            ] if config.command?
            throw error [
              'Invalid Command Configuration:'
              'extended property cannot be declared inside a command'
            ] if config.extended?
            # config.command ?= command if Object.keys(config.commands).length
          config.commands ?= {}
          config.options ?= {}
          config.shortcuts ?= {}
          config.strict ?= false
          for k, v of config.options
            @options(k).set v
          for k, v of config.commands
            @commands(k).set v
          @main.set config.main
        @
      # remove: ->
      #   delete lconfig.options[command]
      raw: ->
        lconfig

## Internal types

    types = ['string', 'boolean', 'integer', 'array']
