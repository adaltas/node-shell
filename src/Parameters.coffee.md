
# Parameters

    registry = []
    register = (plugin) ->
      registry.push plugin

    Parameters = (config) ->
      @registry = []
      @config = {}
      @init()
      @collision = {}
      @configure config
      @confx().set @config
      @
    
    Parameters::init = (->)
  
    Parameters::register = (plugin) ->
      throw error [
        'Invalid Plugin Registration:'
        'plugin must consist of keys representing the hook names'
        'associated with function implementing the hook,'
        "got #{plugin}"
      ] unless is_object_literal plugin
      @registry.push plugin
      @
  
    Parameters::hook = (name, args..., handler) ->
      res = null
      for plugin in registry
        handler = plugin.call @, args..., handler if plugin[name]
      for plugin in @registry
        handler = plugin[name].call @, args..., handler if plugin[name]
      handler.call @, args...
      handler

## `configure(config)`

    Parameters::configure = (config = {}) ->
      config = clone config
      @config = config
      # Sanitize options
      @config

## Method `parse([arguments])`

Convert an arguments list to a parameters object.

* `arguments`: `[string] | string | process` The arguments to parse into parameters, accept the [Node.js process](https://nodejs.org/api/process.html) instance or an [argument list](https://nodejs.org/api/process.html#process_process_argv) provided as an array or a string, optional.
* `options`: `object` Options used to alter the behavior of the `stringify` method.
  * `extended`: `boolean` The value `true` indicates that the parameters are returned in extended format, default to the configuration `extended` value which is `false` by default.
* Returns: `object | [object]` The extracted parameters, a literal object in default flatten mode or an array in extended mode.

    Parameters::parse = (argv = process, options={}) ->
      appconfig = @confx().get()
      options.extended ?= appconfig.extended
      index = 0
      # Remove node and script argv elements
      if argv is process
        index = 2
        argv = argv.argv
      else if typeof argv is 'string'
        argv = argv.split ' '
      else unless Array.isArray argv
        throw error [
          'Invalid Arguments:'
          'parse require arguments or process as first argument,'
          "got #{JSON.stringify process}"
        ]
      # Extracted parameters
      full_params = []
      parse = (config, command) ->
        full_params.push params = {}
        # Add command name provided by parent
        params[appconfig.command] = command if command?
        # Read options
        while true
          break if argv.length is index or argv[index][0] isnt '-'
          key = argv[index++]
          shortcut = key[1] isnt '-'
          key = key.substring (if shortcut then 1 else 2), key.length
          shortcut = key if shortcut
          key = config.shortcuts[shortcut] if shortcut
          option = config.options?[key]
          if not shortcut and config.strict and not option
            err = error [
              'Invalid Argument:'
              "the argument #{if shortcut then "-" else "--"}#{key} is not a valid option"
            ]
            err.command = full_params.slice(1).map (params) ->
              params[appconfig.command]
            throw err
          if shortcut and not option
            throw error [
              'Invalid Shortcut Argument:'
              "the \"-#{shortcut}\" argument is not a valid option"
              "in command \"#{config.command.join ' '}\"" if Array.isArray config.command
            ]
          # Auto discovery
          unless option
            type = if argv[index] and argv[index][0] isnt '-' then 'string' else 'boolean'
            option = name: key, type: type
          switch option.type
            when 'boolean'
              params[key] = true
            when 'string'
              value = argv[index++]
              throw error [
                'Invalid Option:'
                "no value found for option #{JSON.stringify key}"
              ] unless value? and value[0] isnt '-'
              params[key] = value
            when 'integer'
              value = argv[index++]
              throw error [
                'Invalid Option:'
                "no value found for option #{JSON.stringify key}"
              ] unless value? and value[0] isnt '-'
              params[key] = parseInt value, 10
            when 'array'
              value = argv[index++]
              throw error [
                'Invalid Option:'
                "no value found for option #{JSON.stringify key}"
              ] unless value? and value[0] isnt '-'
              params[key] ?= []
              params[key].push value.split(',')...
        # Check if help is requested
        # TODO: this doesnt seem right, also, the test in help.parse seems wrong as well
        helping = false
        for _, option of config.options
          continue unless option.help is true
          helping = true if params[option.name]
        return params if helping
        # Check against required options
        for _, option of config.options
          if option.required
            throw error [
              'Required Option Argument:'
              "the \"#{option.name}\" option must be provided"
            ] unless helping or params[option.name]?
          if option.one_of
            values = params[option.name]
            if not option.required and values isnt undefined
              values = [values] unless Array.isArray values
              for value in values
                throw error [
                  'Invalid Argument Value:'
                  "the value of option \"#{option.name}\""
                  "must be one of #{JSON.stringify option.one_of},"
                  "got #{JSON.stringify value}"
                ] unless value in option.one_of
        # We still have some argument to parse
        if argv.length isnt index
          # Store the full command in the return array
          leftover = argv.slice(index)
          if config.main
            params[config.main.name] = leftover
          else
            command = argv[index++]
            # Validate the command
            throw error [
              'Invalid Argument:'
              "fail to interpret all arguments \"#{leftover.join ' '}\""
            ] unless config.commands[command]
            # Parse child configuration
            parse config.commands[command], command
        # Command mode but no command are found, default to help
        # Default to help is help property is set and no command is found in user args
        # Happens with global options without a command
        if Object.keys(config.commands).length and not command
          params[appconfig.command] = 'help'
        # Check against required main
        main = config.main
        if main and main.required
          throw error [
            'Required Main Argument:'
            "no suitable arguments for #{JSON.stringify main.name}"
          ] unless params[main.name]?
        params
      # Start the parser
      parse appconfig, null
      unless options.extended
        params = {}
        if Object.keys(appconfig.commands).length
          params[appconfig.command] = []
        for command_params in full_params
          for k, v of command_params
            if k is appconfig.command
              params[k].push v
            else
              params[k] = v
      else
        params = full_params
      # Enrich params with default values
      set_default appconfig, params
      params

## Method `stringify(command, [options])`

Convert a parameters object to an arguments array.

* `params`: `object` The parameter object to be converted into an array of arguments, optional.
* `options`: `object` Options used to alter the behavior of the `stringify` method.
  * `extended`: `boolean` The value `true` indicates that the parameters are provided in extended format, default to the configuration `extended` value which is `false` by default.
  * `script`: `string` The JavaScript file being executed by the engine, when present, the engine and the script names will prepend the returned arguments, optional, default is false.
* Returns: `array` The command line arguments.

    Parameters::stringify = (params, options={}) ->
      argv = if options.script then [process.execPath, options.script] else []
      appconfig = @confx().get()
      options.extended ?= appconfig.extended
      throw error [
        'Invalid Stringify Arguments:'
        '2nd argument option must be an object,'
        "got #{JSON.stringify options}"
      ] unless is_object_literal options
      keys = {}
      # In extended mode, the params array will be truncated
      # params = merge params unless extended
      set_default appconfig, params
      # Convert command parameter to a 1 element array if provided as a string
      params[appconfig.command] = [params[appconfig.command]] if typeof params[appconfig.command] is 'string'
      # Stringify
      stringify = (config, lparams) ->
        for _, option of config.options
          key = option.name
          keys[key] = true
          value = lparams[key]
          # Validate required value
          throw error [
            'Required Option Parameter:'
            "the \"#{key}\" option must be provided"
          ] if option.required and not value?
          # Validate value against option "one_of"
          if value? and option.one_of
            value = [value] unless Array.isArray value
            for val in value
              throw error [
                'Invalid Parameter Value:'
                "the value of option \"#{option.name}\""
                "must be one of #{JSON.stringify option.one_of},"
                "got #{JSON.stringify val}"
              ] unless val in option.one_of
          # Serialize
          if value then switch option.type
            when 'boolean'
              argv.push "--#{key}"
            when 'string', 'integer'
              argv.push "--#{key}"
              argv.push "#{value}"
            when 'array'
              argv.push "--#{key}"
              argv.push "#{value.join ','}"
        if config.main
          value = lparams[config.main.name]
          throw error [
            'Required Main Parameter:'
            "no suitable arguments for #{JSON.stringify config.main.name}"
          ] if config.main.required and not value?
          if value?
            throw error [
              'Invalid Parameter Type:'
              "expect main to be an array, got #{JSON.stringify value}"
            ] unless Array.isArray value
            keys[config.main.name] = value
            argv = argv.concat value
        # Recursive
        has_child_commands = if options.extended then params.length else Object.keys(config.commands).length
        if has_child_commands
          command = if options.extended then params[0][appconfig.command] else params[appconfig.command].shift()
          throw error [
            'Invalid Command Parameter:'
            "command #{JSON.stringify command} is not registed,"
            "expect one of #{JSON.stringify Object.keys(config.commands).sort()}"
            "in command #{JSON.stringify config.command.join ' '}" if Array.isArray config.command
          ] unless config.commands[command]
          argv.push command
          keys[appconfig.command] = command
          # Stringify child configuration
          stringify config.commands[command], if options.extended then params.shift() else lparams
        if options.extended or not has_child_commands
          # Handle params not defined in the configuration
          # Note, they are always pushed to the end and associated with the deepest child
          for key, value of lparams
            continue if keys[key]
            throw Error [
              'Invalid Parameter:'
              "the property --#{key} is not a registered argument"
            ].join ' ' if appconfig.strict
            if typeof value is 'boolean'
              argv.push "--#{key}" if value
            else if typeof value is 'undefined' or value is null
              # nothing
            else
              argv.push "--#{key}"
              argv.push "#{value}"
      stringify appconfig, if options.extended then params.shift() else params
      argv

## Method `helping(params)`

Determine if help was requested by returning zero to n commands if help is requested or null otherwise.

* `params`: `[object] | object` The parameter object parsed from arguments, an object in flatten mode or an array in extended mode, optional.
* Returns: `array | null` The formatted help to be printed.

    Parameters::helping = (params, options={}) ->
      params = clone params
      appconfig = @confx().get()
      options.extended ?= appconfig.extended
      unless options.extended
        throw error [
          "Invalid Arguments:"
          "`helping` expect a params object as first argument"
          "in flatten mode,"
          "got #{JSON.stringify params}"
        ] unless is_object_literal params
      else
        throw error [
          "Invalid Arguments:"
          "`helping` expect a params array with literal objects as first argument"
          "in extended mode,"
          "got #{JSON.stringify params}"
        ] unless Array.isArray(params) and not params.some (cparams) -> not is_object_literal cparams
      # Extract the current commands from the parameters arguments
      unless options.extended
        throw error [
          'Invalid Arguments:'
          "parameter #{JSON.stringify appconfig.command} must be an array in flatten mode,"
          "got #{JSON.stringify params[appconfig.command]}"
        ] if params[appconfig.command] and not Array.isArray params[appconfig.command]
        # In flatten mode, extract the commands from params
        commands = params[appconfig.command] or []
      else
        commands = params.slice(1).map (cparams) ->
          cparams[appconfig.command]
      # Handle help command
      # if this is the help command, transform the leftover into a new command
      if commands.length and appconfig.commands and appconfig.commands[commands[0]].help
        helping = true
        # Note, when argv equals ['help'], there is no leftover and main is null
        leftover = unless options.extended
        then params[appconfig.commands[commands[0]].main.name]
        else params[1][appconfig.commands[commands[0]].main.name]
        return if leftover then leftover else []
      # Handle help option:
      # search if the help option is provided and for which command it apply
      search = (config, commands, params) ->
        cparams = unless options.extended then params else params.shift()
        helping = Object.values(config.options)
        # Search the help option
        .filter (options) -> options.help
        # Check if it is present in the parsed parameters
        .some (options) -> cparams[options.name]?
        if helping
          throw error [
            'Invalid Argument:'
            '`help` must be associated with a leaf command'
          ] if options.extended and commands.length
          return true
        # Helping is not requested and there are no more commands to search
        return false unless commands?.length
        command = commands.shift()
        return false if options.extended and params.length is 0
        config = config.commands[command]
        search config, commands, params
      helping = search appconfig, clone(commands), params
      if helping then commands else null

## Method `help(command)`

Format the configuration into a readable documentation string.

* `command`: `[string] | string` The string or array containing the command name if any, optional.
* Returns: `string` The formatted help to be printed.
    
    Parameters::help = (commands=[], options={}) ->
      commands = commands.split ' ' if typeof commands is 'string'
      throw error [
        'Invalid Help Arguments:'
        'expect commands to be an array as first argument,'
        "got #{JSON.stringify commands}"
      ] unless Array.isArray commands
      config = appconfig = @confx().get()
      configs = [config]
      for command, i in commands
        config = config.commands[command]
        throw error [
          'Invalid Command:'
          "argument \"#{commands.slice(0, i+1).join ' '}\" is not a valid command"
        ] unless config
        configs.push config
      # Init
      content = []
      content.push ''
      # Name
      content.push 'NAME'
      name = configs.map((config) -> config.name).join ' '
      description = configs[configs.length-1].description
      content.push "    #{name} - #{description}"
      # Synopsis
      content.push ''
      content.push 'SYNOPSIS'
      synopsis = []
      for config, i in configs
        synopsis.push config.name
        # Find if there are options other than help
        if Object.values(config.options).some((option) -> not option.help)
          synopsis.push "[#{config.name} options]"
        # Is current config
        if i is configs.length - 1
          # There are more subcommand
          if Object.keys(config.commands).length
            synopsis.push "<#{appconfig.command}>"
          else if config.main
            synopsis.push "{#{config.main.name}}"
      content.push '    ' + synopsis.join ' '
      # Options
      for config in configs.slice(0).reverse()
        if Object.keys(config.options).length or config.main
          content.push ''
          if configs.length is 1
            content.push "OPTIONS"
          else
            content.push "OPTIONS for #{config.name}"
        if Object.keys(config.options).length
          for name in Object.keys(config.options).sort()
            option = config.options[name]
            shortcut = if option.shortcut then "-#{option.shortcut} " else ''
            line = '    '
            line += "#{shortcut}--#{option.name}"
            line = pad line, 28
            if line.length > 28
              content.push line
              line = ' '.repeat 28
            line += option.description or "No description yet for the #{option.name} option."
            line += ' Required.' if option.required
            content.push line
        if config.main
          line = '    '
          line += "#{config.main.name}"
          line = pad line, 28
          if line.length > 28
            content.push line
            line = ' '.repeat 28
          line += config.main.description or "No description yet for the #{config.main.name} option."
          content.push line
      # Command
      config = configs[configs.length - 1]
      if Object.keys(config.commands).length
        content.push ''
        content.push 'COMMANDS'
        for _, command of config.commands
          line = ["#{command.name}"]
          line = pad "    #{line.join ' '}", 28
          if line.length > 28
            content.push line
            line = ' '.repeat 28
          line += command.description or "No description yet for the #{command.name} command."
          content.push line
        # Detailed command information
        if options.extended then for _, command of config.commands
          content.push ''
          content.push "COMMAND \"#{command.name}\""
          # Raw command, no main, no child commands
          if not Object.keys(command.commands).length and not command.main?.required
            line = "#{command.name}"
            line = pad "    #{line}", 28
            if line.length > 28
              content.push line
              line = ' '.repeat 28
            line += command.description or "No description yet for the #{command.name} command."
            content.push line
          # Command with main
          if command.main
            line = "#{command.name} {#{command.main.name}}"
            line = pad "    #{line}", 28
            if line.length > 28
              content.push line
              line = ' '.repeat 28
            line += command.main.description or "No description yet for the #{command.main.name} option."
            content.push line
          # Command with child commands
          if Object.keys(command.commands).length
            line = ["#{command.name}"]
            if Object.keys(command.options).length
              line.push "[#{command.name} options]"
            line.push "<#{command.command}>"
            content.push '    ' + line.join ' '
            commands = Object.keys command.commands
            if commands.length is 1
              content.push "    Where command is #{Object.keys command.commands}."
            else if commands.length > 1
              content.push "    Where command is one of #{Object.keys(command.commands).join ', '}."
      # Add examples
      config = configs[configs.length - 1]
      has_help_option = Object.values(config.options).some (option) -> option.name is 'help'
      has_help_command = Object.values(config.commands).some (command) -> command.name is 'help'
      has_help_option = true
      content.push ''
      content.push 'EXAMPLES'
      cmd = configs.map((config) -> config.name).join  ' '
      if has_help_option
        line = pad "    #{cmd} --help", 28
        if line.length > 28
          content.push line
          line = ' '.repeat 28
        line += 'Show this message'
        content.push line
      if has_help_command
        line = pad "    #{cmd} help", 28
        if line.length > 28
          content.push line
          line = ' '.repeat 28
        line += 'Show this message'
        content.push line
      content.push ''
      content.join '\n'

## `load(module)`

* `module`   
  Name of the module to load, required.

Load and return a module, use `require.main.require` by default but can be
overwritten by the `load` options passed in the configuration.

    Parameters::load = (module) ->
      throw Error [
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
        
    module.exports = Parameters

## Dependencies

    pad = require 'pad'
    path = require 'path'
    stream = require 'stream'
    load = require './utils/load'
    error = require './utils/error'
    {clone, merge, is_object_literal} = require 'mixme'

## Internal types

    types = ['string', 'boolean', 'integer', 'array']

## Utils

Convert an array to an object

    array_to_object = (elements, key) ->
      opts = {}
      for element in elements
        opts[element[key]] = element
      opts

Given a configuration, apply default values to the parameters

    set_default = (config, params, tempparams = null) ->
      tempparams = merge params unless tempparams?
      if Object.keys(config.commands).length
        command = tempparams[config.command]
        command = tempparams[config.command].shift() if Array.isArray command
        # We are not validating if the command is valid, it may not be set if help option is present
        # throw Error "Invalid Command: \"#{command}\"" unless config.commands[command]
        if config.commands[command]
          params = set_default config.commands[command], params, tempparams
      for _, option of config.options
        params[option.name] ?= option.default if option.default?
      params
