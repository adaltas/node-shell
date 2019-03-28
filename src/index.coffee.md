
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
      @config = config
      # Sanitize options
      sanitize_options = (config) ->
        config.options ?= {}
        # Convert from object with keys as options name to an array
        config.options = array_to_object config.options, 'name' if Array.isArray config.options
        for name, option of config.options
          option.name = name
          option.type ?= 'string'
          throw Error "Invalid option type #{JSON.stringify option.type}" unless option.type in types
          config.shortcuts[option.shortcut] = option.name if option.shortcut
          option.one_of = [option.one_of] if typeof option.one_of is 'string'
          throw Error "Invalid option one_of \"#{JSON.stringify option.one_of}\"" if option.one_of and not Array.isArray option.one_of
      sanitize_command = (command, parent) ->
        command.strict ?= parent.strict
        command.shortcuts = {}
        # command.command ?= parent.command
        throw Error "Invalid Configuration: command property can only be declared at the application level, not inside a command, got #{command.command}" if command.command?
        throw Error 'Invalid Command: flatten cannot be declared inside a command' if command.flatten?
        sanitize_options command
        sanitize_commands command
        command
      sanitize_commands = (config) ->
        config.commands ?= {}
        config.commands = array_to_object config.commands, 'name' if Array.isArray config.commands
        for name, command of config.commands
          throw Error "Incoherent Command Name: key #{JSON.stringify name} is not equal with name #{JSON.stringify command.name}" if command.name and command.name isnt name
          command.name = name
          # command.description ?= "No description yet for the #{command.name} command"
          sanitize_command command, config
      # An object where key are command and values are object map between shortcuts and names
      config.name ?= 'myapp'
      config.flatten ?= true
      throw Error "Invalid Configuration: flatten must be a boolean, got #{JSON.stringify config.flatten}" unless typeof config.flatten is 'boolean'
      config.root = true
      config.description ?= 'No description yet'
      config.shortcuts = {}
      config.strict ?= false
      sanitize_options config
      sanitize_commands config
      if Object.keys(config.commands).length
        config.command ?= 'command'
        command = sanitize_command
          name: 'help'
          description: "Display help information about #{config.name}"
          main:
            name: 'name'
            description: 'Help about a specific command'
          help: true
        , config
        config.commands[command.name] = mixme command, config.commands[command.name]
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
      sanitize_options_enrich config
      sanitize_commands_enrich = (config) ->
        for name, command of config.commands
          command.description ?= "No description yet for the #{command.name} command"
          sanitize_commands_enrich command, config
      sanitize_commands_enrich config
      @

## `run(argv)` or `run(params)` or `run(process)`

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
      run: function(){ return 'something'; }
      options: [
        name: 'debug'
      ]
    ]
  ).run ['start', '-d', 'Hello']
```

    Parameters.prototype.run = (argv = process, args...) ->
      if Array.isArray(argv)
        params = @parse argv
      else if argv is process
        params = @parse argv
      else if is_object argv
        params = argv
      else
        throw Error "Invalid Arguments: first argument must be an argv array, a params object or the process object, got #{JSON.stringify argv}"
      # Print help
      # return unless params
      if commands = @helping params
        [helpconfig] = Object.values(@config.commands).filter (command) -> command.help
        throw Error "No Help Command" unless helpconfig
        run = helpconfig.run
        throw Error 'Missing "run" definition for help: please insert a command of name "help" with a "run" property inside' unless run
      else if params[@config.command]
        run = @config.commands[params[@config.command]].run
        extended = @config.commands[params[@config.command]].extended
        throw Error "Missing \"run\" definition for command #{JSON.stringify params[@config.command]}" unless run
      else
        run = @config.run
        extended = @config.extended
        throw Error 'Missing run definition' unless run
      # Load the module
      run = @load run if typeof run is 'string'
      inject = [params]
      inject.push argv if extended
      inject.push @config if extended
      run.call @, inject..., args...

## `parse([argv])`

* `argv` (array|process|string, optional)   
  Array of arguments to parse, optional.

Convert process arguments into a usable object. Argument may
be in the form of a string or an array. If not provided, it 
parse the arguments present in  `process.argv`.

When provided as an array or a string, only pass the parameters without the script name.

Example:

```
params = argv.parse ['start', '--watch', __dirname, '-s', 'my', '--command']
params.should.eql
  action: 'start'
  watch: __dirname
  strict: true
  command: 'my --command'
```

    Parameters.prototype.parse = (argv = process) ->
      # argv = argv.split ' ' if typeof argv is 'string'
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
          # Store the full command in the return object
          leftover = argv.slice(index).join(' ')
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
        # Tommand mode but no command are found, default to help
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
      # console.log full_params
      if @config.flatten
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

## `stringify([script], params, [options])`

* `script`   
  A script which will prefixed the arguments, optional.
* `params`   
  Parameter object to stringify into arguments, required.
* `options`   
  Object containing any options, optional.

Convert an object into process arguments.

    Parameters.prototype.stringify = (params, options={}) ->
      argv = if options.script then [process.execPath, options.script] else []
      keys = {}
      set_default @config, params
      # Stringify
      stringify = (config) =>
        for _, option of config.options
          key = option.name
          keys[key] = true
          value = params[key]
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
          value = params[config.main.name]
          throw Error "Required main argument \"#{config.main.name}\"" if config.main.required and not value?
          keys[config.main.name] = value
          argv.push value if value?
        # Recursive
        if Object.keys(config.commands).length
          command = params[@config.command]
          command = params[@config.command].shift() if Array.isArray command
          argv.push command
          keys[@config.command] = command
          # Stringify child configuration
          throw Error "Invalid Command: \"#{command}\"" unless config.commands[command]
          stringify config.commands[command]
      stringify @config
      # Handle params not defined in the configuration
      # Note, they are always pushed to the end and associated with the deepest child
      for key, value of params
        continue if keys[key]
        throw Error "Invalid option #{JSON.stringify key}" if @config.strict
        if typeof value is 'boolean'
          argv.push "--#{key}" if value
        else if typeof value is 'undefined' or value is null
          # nothing
        else
          argv.push "--#{key}"
          argv.push "#{value}"
      argv

## `helping(params)` or `helping(arv)`

* `params`   
  Parameter object as returned by parsed.
* `argv`   
  An array of CLI arguments.

Return zero to n commands if help not requested or null otherwise.

    Parameters.prototype.helping = ->
      args = Array.prototype.slice.call arguments
      if Array.isArray args[0]
        params = @parse args[0]
      else if is_object args[0]
        params = args[0]
      else
        throw Error "Invalid Arguments: expect a params object or an argv array as first argument, got #{JSON.stringify args[0]}"
      params = mixme params
      commands = []
      # Build the commands array with help and without main
      conf = @config
      while conf
        # Stop if there are no more sub commands
        break unless Object.keys(conf.commands).length
        command = params[conf.command]
        if typeof command is 'string'
          commands.push command
          delete params[conf.command]
        else if Array.isArray command
          commands.push command[0]
          command.shift()
        conf = conf.commands[command]
      conf = @config
      helping = false
      if Object.values(conf.options).filter((option) -> option.help).some( (options) -> params[options.name])
        helping = true
      for command, i in commands
        if Object.values(conf.options).filter((option) -> option.help).some( (options) -> params[options.name])
          helping = true
        if conf.commands[command].help
          helping = true
          commands = commands.slice(0, i)
          if params[conf.commands[command].main.name]
            commands.push params[conf.commands[command].main.name].split(' ')...
          break
        conf = conf.commands[command]
      if helping then commands else null

## `help(params, [options])` or `help(commands..., [options])`

* `params(object)`   
  Parameter object as returned by parsed, required if first argument is an object.
* `commands(strings)`   
  A list of commands passed as strings, required if first argument is a string.
* `options(object)`   
  Object containing any options, optional.

Return a string describing the usage of the overall command or one of its
command.

    Parameters.prototype.help = ->
      args = Array.prototype.slice.call arguments
      # Get options
      if args.length > 1
        options = args.pop() if is_object args[args.length-1]
      # Get commands as an array of sub commands
      if is_object args[0]
        throw Error 'Invalid Arguments: only one argument is expected if first argument is an object' if args.length > 1
        return unless commands = @helping args[0]
      else if Array.isArray args[0]
        for arg in args[0] then throw Error "Invalid Arguments: argument is not a string, got #{JSON.stringify arg}" if typeof arg isnt 'string'
        commands = args[0]
      else if typeof args[0] is 'string'
        for arg in args then throw Error "Invalid Arguments: argument is not a string, got #{JSON.stringify arg}" if typeof arg isnt 'string'
        commands = args
      else if args.length is 0
        commands = []
      else
        throw Error "Invalid Arguments: first argument must be a string, an array or an object, got #{JSON.stringify args[0]}"
      options ?= {}
      # commands = [] if commands.length is 1 and commands[0] is 'help'
      # Build a config array reflecting the hierarchical nature of commands
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
        # has_options = Object.values(config.options).some((option) -> not option.help)
        # if Object.keys(config.options).length
        if Object.values(config.options).some((option) -> not option.help)
          synopsis.push "[#{config.name} options]"
        # Is current config
        if i is configs.length - 1
          # There are more subcommand
          if Object.keys(config.commands).length
            synopsis.push "<#{config.command}>"
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
        # # Detailed command information
        # for _, command of config.commands
        #   content.push ''
        #   content.push "COMMAND \"#{command.name}\""
        #   # Raw command, no main, no child commands
        #   if not Object.keys(command.commands).length and not command.main?.required
        #     line = "#{command.name}"
        #     line = pad "    #{line}", 28
        #     if line.length > 28
        #       content.push line
        #       line = ' '.repeat 28
        #     line += command.description or "No description yet for the #{command.name} command."
        #     content.push line
        #   # Command with main
        #   if command.main
        #     line = "#{command.name} {#{command.main.name}}"
        #     line = pad "    #{line}", 28
        #     if line.length > 28
        #       content.push line
        #       line = ' '.repeat 28
        #     line += command.main.description or "No description yet for the #{command.main.name} option."
        #     content.push line
        #   # Command with child commands
        #   if Object.keys(command.commands).length
        #     line = ["#{command.name}"]
        #     if Object.keys(command.options).length
        #       line.push "[#{command.name} options]"
        #     line.push "<#{command.command}>"
        #     content.push '    ' + line.join ' '
        #     commands = Object.keys command.commands
        #     if commands.length is 1
        #       content.push "    Where command is #{Object.keys command.commands}."
        #     else if commands.length > 1
        #       content.push "    Where command is one of #{Object.keys(command.commands).join ', '}."
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

    Parameters.prototype.load = (module) ->
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
