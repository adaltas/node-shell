
pad = require 'pad' 
load = require './load'
merge = require './merge'

types = ['string', 'boolean', 'integer', 'array']

###
# parameters(config)

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

###
Parameters = (config = {}) ->
  @config = config
  # Sanitize options
  sanitize_options = (config) ->
    config.options ?= {}
    # Convert from object with keys as options name to an array
    config.options = array_to_object config.options, 'name' if Array.isArray config.options
    for name, option of config.options
      option.name = name
      # Access option by key
      option.type ?= 'string'
      throw Error "Invalid option type #{JSON.stringify option.type}" unless option.type in types
      config.shortcuts[option.shortcut] = option.name if option.shortcut
      option.one_of = [option.one_of] if typeof option.one_of is 'string'
      throw Error "Invalid option one_of \"#{JSON.stringify option.one_of}\"" if option.one_of and not Array.isArray option.one_of
  sanitize_command = (command, parent) ->
    command.strict ?= parent.strict
    command.shortcuts = {}
    command.command ?= parent.command
    sanitize_options command
    sanitize_commands command
    command
  sanitize_commands = (config) ->
    config.commands ?= {}
    config.commands = array_to_object config.commands, 'name' if Array.isArray config.commands
    for name, command of config.commands
      throw Error "Incoherent Command Name: key #{JSON.stringify name} is not equal with name #{JSON.stringify command.name}" if command.name and command.name isnt name
      command.name = name
      command.description ?= "No description yet for the #{command.name} command"
      sanitize_command command, config
  # An object where key are command and values are object map between shortcuts and names
  config.name ?= 'myapp'
  config.description ?= 'No description yet'
  config.shortcuts = {}
  config.strict ?= false
  config.command ?= 'command'
  sanitize_options config
  sanitize_commands config
  unless config.commands.help
    if Object.keys(config.commands).length
      command = sanitize_command
        name: 'help'
        description: "Display help information about #{config.name}"
        main:
          name: 'name'
          description: 'Help about a specific command'
      , config
      config.commands[command.name] = command
    else 
      config.options['help'] =
        name: 'help'
        shortcut: 'h'
        description: 'Display help information'
        type: 'boolean'
  @

###

## `run([argv])`

Parse the arguments and execute the module defined by the "module" option.

You should only pass the parameters and the not the script name.

Example

  result = parameters(
    commands: [
      name: 'start'
      run: function(){ return 'something'; }
      options: [
        name: 'debug'
      ]
    ]
  ).run ['start', '-d', 'Hello']

###
Parameters.prototype.run = (argv = process, args...) ->
  params = @parse argv
  if params[@config.command]
    run = @config.commands[params[@config.command]].run
    extended = @config.commands[params[@config.command]].extended
    throw Error "Missing run definition for command #{JSON.stringify params[@config.command]}" unless run
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

###

## `load(module)`

Load and return a module, use `require.main.require` by default.

###

Parameters.prototype.load = (module) ->
  unless @config.load
    load module
  else
    if typeof @config.load is 'string'
      load(@config.load)(module)
    else
      @config.load module
  

###

## `parse([argv])`

Convert process arguments into a usable object. Argument may
be in the form of a string or an array. If not provided, it 
parse the arguments present in  `process.argv`.

You should only pass the parameters and the not the script name.

Example

  params = argv.parse ['start', '--watch', __dirname, '-s', 'my', '--command']
  params.should.eql
    action: 'start'
    watch: __dirname
    strict: true
    command: 'my --command'

###
Parameters.prototype.parse = (argv = process) ->
  argv = argv.split ' ' if typeof argv is 'string'
  index = 0
  # Remove node and script argv elements
  if argv is process
    index = 2
    argv = argv.argv
  # Extracted parameters
  params = {}
  parse = (config) =>
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
      throw Error "Invalid shortcut '#{shortcut}'" if shortcut and not option
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
    # Check against required options
    for _, option of config.options
      if option.required
        throw Error "Required option argument \"#{option.name}\"" unless params.help or params[option.name]?
      if option.one_of
        values = params[option.name]
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
        command = argv[index]
        # Validate the command
        throw Error "Fail to parse end of command \"#{leftover}\"" unless config.commands[command]
        # Set the parameter relative to the command
        if typeof params[config.command] is 'string'
          params[config.command] = [params[config.command]]
        if Array.isArray params[config.command]
          params[config.command].push argv[index++]
        else
          params[config.command] = argv[index++]
        # Parse child configuration
        parse config.commands[command], argv
    # Command mode but no command are found, default to help
    # Happens with global options without a command
    if Object.keys(@config.commands).length and not params[@config.command]
      params[@config.command] = 'help'
    # Check against required main
    main = config.main
    if main
      if main.required
        throw Error "Required main argument \"#{main.name}\"" unless params[main.name]?
    params
  # If they are commands (other than help) and no arguments are provided,
  # we default to the help action
  if Object.keys(@config.commands).length and argv.length is index
    argv.push 'help'
  if Object.keys(@config.commands).length and argv[index].substr(0,1) isnt '-'
    config = @config.commands[argv[index]]
    throw Error "Invalid Command: \"#{argv[index]}\"" unless config
    params[@config.command] = argv[index++]
  else
    config = @config
  # Start the parser
  params = parse config, argv
  # Enrich params with default values
  set_default @config, params
  params

###

## `stringify([script], params)`

Convert an object into process arguments.

###
Parameters.prototype.stringify = (params, options={}) ->
  argv = if options.script then [process.execPath, options.script] else []
  keys = {}
  # Validate command
  # if params[@config.command]
  #   throw Error "Invalid Command '#{params[@config.command]}'" unless @config.commands[params[@config.command]]
  # Enrich params with default values
  # if params[@config.command]
  #   for _, option of @config.commands[params[@config.command]].options
  #     params[option.name] ?= option.default if option.default?
  # for _, option of @config.options
  #   params[option.name] ?= option.default if option.default?
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
      command = params[config.command]
      command = params[config.command].shift() if Array.isArray command
      argv.push command
      keys[config.command] = command
      # Stringify child configuration
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

###

## `help([command])`

Return a string describing the usage of the overall command or one of its
command.

###
Parameters.prototype.help = (commands...) ->
  commands = [] if commands.length is 1 and commands[0] is 'help'
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
    if Object.keys(config.options).length
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
  # config = configs[configs.length - 1]
    if Object.keys(config.options).length or config.main
      content.push ''
      if configs.length is 1
        content.push "OPTIONS"
      else
        content.push "OPTIONS for #{config.name}"
    if Object.keys(config.options).length
      for _, option of config.options
        # console.log option
        shortcut = if option.shortcut then "-#{option.shortcut} " else ''
        line = '    '
        line += "#{shortcut}--#{option.name}"
        # line += ' (required)' if option.required
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
    # if Object.keys(config.options).length or config.main
    #   content.push ''
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
    for _, command of config.commands
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
  console.log content.join '\n'
  console.log ''
  return content.join '\n'
  if command
    throw Error "Invalid Command: \"#{command}\"" unless @config.commands[command]
    command = @config.commands[command]
  describeOption = (option, pad_option, pad_description) ->
    shortcut = if option.shortcut then "-#{option.shortcut} " else ''
    content = ' '.repeat pad_option
    content += pad "#{shortcut}--#{option.name}", pad_description - pad_option
    content += option.description
    content += '\n'
  describeCommand = (command) ->
    {description} = command
    content = pad "    #{command.name}", 24
    content += command.description
    content += '\n'
    if command.options then for _, option of command.options
      content += describeOption option, 6, 26
    if command.main
      content += pad "      #{command.main.name}", 26
      content += command.main.description
      content += '\n'
    content
  if command and command.name isnt 'help'
    # Command help
    synopsis = @config.name + ' ' + command.name
    if Object.keys(command.options).length
      options = 'options...'
      options = "[#{options}]" unless (Object.values(command.options).filter (o) -> o.required).length
      synopsis += " #{options}"
    if command.main
      main = "#{command.main.name}"
      main = "[#{main}]" unless command.main.required
      synopsis += " #{main}"
    content = """
    NAME
        #{@config.name} #{command.name} - #{command.description}
    SYNOPSIS
        #{synopsis}
    DESCRIPTION

    """
    content += describeCommand command
  else
    {name, description} = @config
    # Full help
    content = """
    NAME
        #{@config.name} - #{@config.description}

    """
    content += 'SYNOPSIS\n'
    content += "    #{name}"
    content += ' command' if Object.keys(@config.commands).length
    content += ' [options...]'
    content += '\n'
    if Object.keys(@config.commands).length
      content += '    where command is one of'
      content += '\n'
    for _, command of @config.commands
      content += pad "      #{command.name}", 24
      content += command.description or "No description yet for the #{command.name} command"
      content += '\n'
    if Object.keys(@config.options).length or @config.main
      content += 'OPTIONS\n'
      # Describe each option
      for _, option of @config.options
        content += describeOption option, 4, 24
      if @config.main
        content += pad "    #{@config.main.name}", 24
        content += @config.main.description
        content += '\n'
    # Describe each command
    if Object.keys(@config.commands).length
      content += 'COMMANDS\n'
      for _, command of @config.commands
        content += describeCommand command
    # Add examples
    content += 'EXAMPLES\n'
    if Object.keys(@config.commands).length
      content += pad "    #{@config.name or '/path/to/app'} help", 24
      content += "Show this message"
    else
      content += pad "    #{@config.name or '/path/to/app'} --help", 24
      content += "Show this message"
    content += '\n'
    content

module.exports = (config) ->
  new Parameters config
module.exports.Parameters = Parameters

# Distinguish plain literal object from arrays
is_object = (obj) ->
  obj and typeof obj is 'object' and not Array.isArray obj

# Convert an array to an object
array_to_object = (elements, key) ->
    opts = {}
    for element in elements
      opts[element[key]] = element
    opts

# Given a configuration, apply default values to the parameters
set_default = (config, params, tempparams = null) ->
  tempparams = merge {}, params unless tempparams?
  if Object.keys(config.commands).length
    command = tempparams[config.command]
    command = tempparams[config.command].shift() if Array.isArray command
    throw Error "Invalid Command: \"#{command}\"" unless config.commands[command]
    params = set_default config.commands[command], params, tempparams
  for _, option of config.options
    params[option.name] ?= option.default if option.default?
  params
