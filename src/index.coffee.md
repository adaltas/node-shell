
# Parameters

Usage: `parameters(config)`

## About options

Options are defined at the "config" level or for each command.

## About main

Main is what's left after the options. Like options, "main" is 
defined at the "config" level or for each command.

Parameters are defined with the following properties:

* name:     name of the two dash parameter in the command (eg "--my_name") and in the returned parse object unless label is defined.
* label:    not yet implemented, see name
* shortcut: name of the one dash parameter in the command (eg "-n"), must be one charactere
* required: boolean, throw an exception when true and the parameter is not defined
* type:     one of 'string', 'boolean', 'integer' or 'array'

    Parameters = (config = {}) ->
      @configure config
      @

## `configure(config)`

    Parameters::configure = (config) ->
      @config = config
      properties = {}
      # Sanitize options
      sanitize_options = (config) =>
        config.options ?= {}
        # Convert from object with keys as options name to an array
        config.options = array_to_object config.options, 'name' if Array.isArray config.options
        for name, option of config.options
          # Prevent collision
          throw Error [
            'Invalid Option Configuration:'
            "option #{JSON.stringify name}"
            "in command #{JSON.stringify config.command.join ' '}"
            "collide with the one in #{if properties[name].length is 0 then 'application' else JSON.stringify properties[name].join ' '},"
            "change its name or use the extended property"
          ].join ' ' if properties[name] and not @config.extended
          properties[name] = if config.root then [] else config.command
          # Normalize option
          option.name = name
          option.type ?= 'string'
          throw Error "Invalid option type #{JSON.stringify option.type}" unless option.type in types
          config.shortcuts[option.shortcut] = option.name if option.shortcut
          option.one_of = [option.one_of] if typeof option.one_of is 'string'
          throw Error "Invalid option one_of \"#{JSON.stringify option.one_of}\"" if option.one_of and not Array.isArray option.one_of
      # Sanitize main
      sanitize_main = (config) ->
        return config unless config.main
        config.main = name: config.main if typeof config.main is 'string'
      sanitize_command = (command, parent) ->
        command.strict ?= parent.strict
        command.shortcuts = {}
        # command.command ?= parent.command
        throw Error 'Invalid Command: extended cannot be declared inside a command' if command.extended?
        sanitize_main command
        sanitize_options command
        sanitize_commands command
        command
      sanitize_commands = (config) ->
        config.commands ?= {}
        config.commands = array_to_object config.commands, 'name' if Array.isArray config.commands
        for name, command of config.commands
          throw Error "Incoherent Command Name: key #{JSON.stringify name} is not equal with name #{JSON.stringify command.name}" if command.name and command.name isnt name
          command.name = name
          throw Error [
            'Invalid Command Configuration:'
            'command property can only be declared at the application level,'
            "not inside a command, got #{command.command}"
          ].join ' ' if command.command?
          command.command = if config.root then [name] else [...config.command, name]
          sanitize_command command, config
      # An object where key are command and values are object map between shortcuts and names
      config.name ?= 'myapp'
      config.extended ?= false
      throw Error "Invalid Configuration: extended must be a boolean, got #{JSON.stringify config.extended}" unless typeof config.extended is 'boolean'
      config.root = true
      config.description ?= 'No description yet'
      config.shortcuts = {}
      config.strict ?= false
      sanitize_main config
      sanitize_options config
      sanitize_commands config
      sanitize_help_command = (config) ->
        return unless Object.keys(config.commands).length
        config.command ?= 'command'
        command = sanitize_command
          name: 'help'
          description: "Display help information about #{config.name}"
          command: ['help']
          main:
            name: 'name'
            description: 'Help about a specific command'
          help: true
        , config
        config.commands[command.name] = mixme command, config.commands[command.name]
      sanitize_help_command @config
      # Second pass, add help options and set default
      sanitize_options_enrich = (command) ->
        # No "help" option for command "help"
        unless command.help
          command.options['help'] = mixme command.options['help'],
            name: 'help'
            shortcut: 'h'
            description: 'Display help information'
            type: 'boolean'
            help: true
          command.shortcuts[command.options['help'].shortcut] = command.options['help'].name if command.options['help'].shortcut
        for _, cmd of command.commands
          sanitize_options_enrich cmd
      sanitize_options_enrich @config
      sanitize_commands_enrich = (config) ->
        for name, command of config.commands
          command.description ?= "No description yet for the #{command.name} command"
          sanitize_commands_enrich command, config
      sanitize_commands_enrich @config

## `route(argv)` or `route(params)` or `route(process)`

* `argv`   
  Array of arguments to parse, optional.
* `params`   
  Paramters object as returned by `parse`, optional.
* `process`   
  The Node.js process object, optional.

Parse the arguments and execute the module defined by the "module" option.

You should only pass the parameters and the not the script name.

Example:

```
  result = parameters(
    commands: [
      name: 'start'
      route: function(){ return 'something'; }
      options: [
        name: 'debug'
      ]
    ]
  ).route ['start', '-d', 'Hello']
```

    Parameters::route = (argv = process, args...) ->
      if Array.isArray(argv)
        params = @parse argv
      else if argv is process
        params = @parse argv
      else if is_object argv
        params = argv
      else
        throw Error "Invalid Arguments: first argument must be an argv array, a params object or the process object, got #{JSON.stringify argv}"
      # Print help
      if commands = @helping params
        [helpconfig] = Object.values(@config.commands).filter (command) -> command.help
        throw Error "No Help Command" unless helpconfig
        route = helpconfig.route
        throw Error 'Missing "route" definition for help: please insert a command of name "help" with a "route" property inside' unless route
      else if params[@config.command]
        route = @config.commands[params[@config.command]].route
        extended = @config.commands[params[@config.command]].extended
        throw Error "Missing \"route\" definition for command #{JSON.stringify params[@config.command]}" unless route
      else
        route = @config.route
        extended = @config.extended
        throw Error 'Missing route definition' unless route
      # Load the module
      route = @load route if typeof route is 'string'
      route.call @, {params: params, argv: argv, config: @config}, ...args

## Method `parse([arguments])`

Convert an arguments list to a parameters object.

* `arguments`: `[string] | string | process` The arguments to parse into parameters, accept the [Node.js process](https://nodejs.org/api/process.html) instance or an [argument list](https://nodejs.org/api/process.html#process_process_argv) provided as an array or a string, optional.
* `options`: `object` Options used to alter the behavior of the `stringify` method.
  * `extended`: `boolean` The value `true` indicates that the parameters are returned in extended format, default to the configuration `extended` value which is `false` by default.
* Returns: `object | [object]` The extracted parameters, a literal object in default flatten mode or an array in extended mode.

    Parameters::parse = (argv = process, options={}) ->
      options.extended ?= @config.extended
      index = 0
      # Remove node and script argv elements
      if argv is process
        index = 2
        argv = argv.argv
      else if typeof argv is 'string'
        argv = argv.split ' '
      else unless Array.isArray argv
        throw Error "Invalid Arguments: parse require arguments or process as first argument, got #{JSON.stringify process}"
      # Extracted parameters
      full_params = []
      parse = (config) =>
        full_params.push params = {}
        # Read options
        while true
          break if argv.length is index or argv[index][0] isnt '-'
          key = argv[index++]
          shortcut = key[1] isnt '-'
          key = key.substring (if shortcut then 1 else 2), key.length
          shortcut = key if shortcut
          key = config.shortcuts[shortcut] if shortcut
          option = config.options?[key]
          throw Error "Invalid option #{JSON.stringify key}" if not shortcut and config.strict and not option
          if shortcut and not option
            if config.root
              throw Error "Invalid Shortcut: \"-#{shortcut}\""
            else
              throw Error "Invalid Shortcut: \"-#{shortcut}\" in command \"#{config.name}\""
          # Auto discovery
          unless option
            type = if argv[index] and argv[index][0] isnt '-' then 'string' else 'boolean'
            option = name: key, type: type
          switch option.type
            when 'boolean'
              params[key] = true
            when 'string'
              value = argv[index++]
              throw Error "Invalid Option: no value found for option #{JSON.stringify key}" unless value?
              throw Error "Invalid Option: no value found for option #{JSON.stringify key}" if value[0] is '-'
              params[key] = value
            when 'integer'
              value = argv[index++]
              throw Error "Invalid Option: no value found for option #{JSON.stringify key}" unless value?
              throw Error "Invalid Option: no value found for option #{JSON.stringify key}" if value[0] is '-'
              params[key] = parseInt value, 10
            when 'array'
              value = argv[index++]
              throw Error "Invalid Option: no value found for option #{JSON.stringify key}" unless value?
              throw Error "Invalid Option: no value found for option #{JSON.stringify key}" if value[0] is '-'
              params[key] ?= []
              params[key].push value.split(',')...
        # Check if help is requested
        helping = false
        for _, option of config.options
          continue unless option.help is true
          helping = true if params[option.name]
        return params if helping
        # Check against required options
        for _, option of config.options
          if option.required
            throw Error "Required option argument \"#{option.name}\"" unless helping or params[option.name]?
          if option.one_of
            values = params[option.name]
            if not option.required and values isnt undefined
              values = [values] unless Array.isArray values
              for value in values
                throw Error "Invalid value \"#{value}\" for option \"#{option.name}\"" unless value in option.one_of
        # We still have some argument to parse
        if argv.length isnt index
          # Store the full command in the return array
          leftover = argv.slice(index)
          if config.main
            params[config.main.name] = leftover
          else
            command = argv[index++]
            # Validate the command
            throw Error "Fail to parse end of command \"#{leftover}\"" unless config.commands[command]
            # Parse child configuration
            child_params = parse(config.commands[command], argv)
            # Enrich child with command
            child_params[@config.command] = command
        # Command mode but no command are found, default to help
        # Default to help is help property is set and no command is found in user args 
        # Happens with global options without a command
        if Object.keys(config.commands).length and not command
          params[@config.command] = 'help'
        # Check against required main
        main = config.main
        if main
          if main.required
            throw Error "Required main argument \"#{main.name}\"" unless params[main.name]?
        params
      # Start the parser
      parse @config, argv
      unless options.extended
        params = {}
        if Object.keys(@config.commands).length
          params[@config.command] = []
        for command_params in full_params
          for k, v of command_params
            if k is @config.command
              params[k].push v
            else
              params[k] = v
      else
        params = full_params
      # Enrich params with default values
      set_default @config, params
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
      options.extended ?= @config.extended
      throw Error "Invalid Arguments: 2nd argument option must be an object, got #{JSON.stringify options}" unless is_object options
      keys = {}
      # In extended mode, the params array will be truncated
      # params = mixme params unless extended
      set_default @config, params
      # Convert command parameter to a 1 element array if provided as a string
      params[@config.command] = [params[@config.command]] if typeof params[@config.command] is 'string'
      # Stringify
      stringify = (config, lparams) =>
        for _, option of config.options
          key = option.name
          keys[key] = true
          value = lparams[key]
          # Validate required value
          throw Error "Required option argument \"#{key}\"" if option.required and not value?
          # Validate value against option "one_of"
          if value? and option.one_of
            value = [value] unless Array.isArray value
            for val in value
              throw Error "Invalid value \"#{val}\" for option \"#{option.name}\"" unless val in option.one_of
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
          throw Error "Required main argument \"#{config.main.name}\"" if config.main.required and not value?
          if value?
            throw Error "Invalid Arguments: expect main to be an array, got #{JSON.stringify value}" unless Array.isArray value
            keys[config.main.name] = value
            argv = argv.concat value
        # Recursive
        has_child_commands = if options.extended then params.length else Object.keys(config.commands).length
        if has_child_commands
          command = if options.extended then params[0][@config.command] else params[@config.command].shift()
          throw Error "Invalid Command: command #{JSON.stringify command} is not registed" unless config.commands[command]
          argv.push command
          keys[@config.command] = command
          # Stringify child configuration
          stringify config.commands[command], if options.extended then params.shift() else lparams
        if options.extended or not has_child_commands
          # Handle params not defined in the configuration
          # Note, they are always pushed to the end and associated with the deepest child
          for key, value of lparams
            continue if keys[key]
            throw Error "Invalid option #{JSON.stringify key}" if @config.strict
            if typeof value is 'boolean'
              argv.push "--#{key}" if value
            else if typeof value is 'undefined' or value is null
              # nothing
            else
              argv.push "--#{key}"
              argv.push "#{value}"
      stringify @config, if options.extended then params.shift() else params
      argv

## Method `helping(params)`

Determine if help was requested by returning zero to n commands if help is requested or null otherwise.

* `params`: `[object] | object` The parameter object parsed from arguments, an object in flatten mode or an array in extended mode, optional.
* Returns: `array | null` The formatted help to be printed.

    Parameters::helping = (params) ->
      throw Error [
        "Invalid Arguments:"
        "`helping` expect a params object or an argv array as first argument,"
        "got #{JSON.stringify params}"
      ].join ' ' unless is_object params
      params = mixme params
      params[@config.command] = [params[@config.command]] if typeof params[@config.command] is 'string'
      commands = params[@config.command] or []
      if commands.length and @config.commands and @config.commands[commands[0]].help
        helping = true
        # if argv is ['help'], there is no leftover and main is null
        leftover = params[@config.commands[commands[0]].main.name]
        commands = if leftover then leftover.split() else []
      search = (config) ->
        return true if config.options and Object.values(config.options)
        # Search the help option
        .filter (options) -> options.help
        # Check if it is present in the parsed parameters
        .some (options) -> params[options.name]?
        return false unless commands?.length
        command = commands[0]
        config = config.commands[commands.shift()]
        if config
        then search config
        else throw Error "Invalid Arguments: command #{JSON.stringify command} is not registed"
      helping = search @config unless helping
      if helping then commands else null

## Method `help(command)`

Format the configuration into a readable documentation string.

* `command`: `[string] | string` The string or array containing the command name if any, optional.
* Returns: `string` The formatted help to be printed.

    Parameters::help = (commands=[], options={}) ->
      commands = commands.split ' ' if typeof commands is 'string'
      throw Error "Invalid Arguments: expect commands to be an array as first argument, got #{JSON.stringify commands}" unless Array.isArray commands
      config = @config
      configs = [config]
      for command, i in commands
        config = config.commands[command]
        throw Error "Invalid Command: \"#{commands.slice(0, i+1).join ' '}\"" unless config
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
            synopsis.push "<#{@config.command}>"
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
          for _, option of config.options
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
      unless @config.load
        load module
      else
        if typeof @config.load is 'string'
          load(@config.load)(module)
        else
          @config.load module

    module.exports = (config) ->
      new Parameters config
    module.exports.Parameters = Parameters

## Miscellaneous

Dependencies

    pad = require 'pad' 
    load = require './utils/load'
    mixme = require 'mixme'

Internal types

    types = ['string', 'boolean', 'integer', 'array']

Distinguish plain literal object from arrays

    is_object = (obj) ->
      obj and typeof obj is 'object' and not Array.isArray obj

Convert an array to an object

    array_to_object = (elements, key) ->
        opts = {}
        for element in elements
          opts[element[key]] = element
        opts

Given a configuration, apply default values to the parameters

    set_default = (config, params, tempparams = null) ->
      tempparams = mixme params unless tempparams?
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
