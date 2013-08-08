
path = require 'path'
pad = require 'pad' 

types = ['string', 'boolean', 'integer']

###
parameters(config)
==================

About options
-------------
Options are defined at the "config" level or for each action.

About main
----------
Main is what's left after the options. Like options, "main" is 
defined at the "config" level or for each action.

Parameters are defined with the following properties
*   name:     name of the two dash parameter in the command (eg "--my_name") and in the returned parse object unless label is defined.
*   label:    not yet implemented, see name
*   shortcut: name of the one dash parameter in the command (eg "-n"), must be one charactere
*   required: boolean, throw an exception when true and the parameter is not defined
*   type:     one of 'string', 'boolean' or 'integer'

###
Parameters = (@config = {}) ->
  # Sanitize options
  options = (action) ->
    for option in action.options
      # Access option by key
      do (option) ->
        action.options.__defineGetter__ option.name, -> option
      option.type ?= 'string'
      throw new Error "Invalid type \"#{option.type}\"" if types.indexOf(option.type) is -1
      action.shortcuts[option.shortcut] = option.name
  # An object where key are action and values are object map between shortcuts and names
  config.shortcuts = {}
  config.options ?= []
  options config
  config.action ?= 'action'
  config.actions ?= []
  config.actions = [config.actions] unless Array.isArray config.actions
  makeAction = (action) ->
    config.actions.__defineGetter__ action.name, -> action
    main = action.main
    action.shortcuts = {}
    action.options ?= []
    action.options = [action.options] unless Array.isArray action.options
    options action
  for action in config.actions
    makeAction action
  unless config.actions.help
    if config.actions.length
      actions = 
        name: 'help'
        description: "Display help information about #{config.name}"
        main:
          name: 'command'
          description: 'Help about a specific action'
      config.actions.push actions
      makeAction actions
    else 
      config.options.push 
        name: 'help'
        shortcut: 'h'
        description: "Display help information"
  @

###

`parse([argv])`
----------------

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
    while true
      break if argv.length is index or argv[index].substr(0, 1) isnt '-'
      key = argv[index++]
      shortcut = key.substr(1, 1) isnt '-'
      key = key.substring (if shortcut then 1 else 2), key.length
      key = config.shortcuts[key] if shortcut
      option = config.options?[key]
      throw new Error "Invalid option '#{key}'" unless option
      switch option.type
        when 'boolean'
          value = true
        when 'string'
          value = argv[index++]
        when 'integer'
          value = parseInt argv[index++], 10
      params[key] = value
    # Check against required options
    options = config.options
    if options then for option in options
      if option.required
        throw new Error "Required argument \"#{option.name}\"" unless params[option.name]?
      # params[option.name] ?= null
    # We still have some argument to parse
    if argv.length isnt index
      # Store the full command in the return object
      main = argv.slice(index).join(' ')
      if config.main
        params[config.main.name] = main
      else
        if config.actions?[argv[index]]
          config = @config.actions[argv[index]]
          params[@config.action] = argv[index++]
          parse config, argv
        else
          throw new Error "Fail to parse end of command \"#{main}\""
    # Check against required main
    main = config.main
    if main
      if main.required
        throw new Error "Required main argument \"#{main.name}\"" unless params[main.name]?
      # params[main.name] ?= null
    params
  # If they are actions (other than help) and no arguments are provided,
  # we default to the help action
  if @config.actions.length and argv.length is index
    argv.push 'help'
  if @config.actions.length and argv[index].substr(0,1) isnt '-'
    config = @config.actions[argv[index]]
    throw new Error "Invalid action '#{argv[index]}'" unless config
    params[@config.action] = argv[index++]
  else
    config = @config
  parse config, argv

###

`stringify([script], params)`
------------------------

Convert an object into process arguments.

###
Parameters.prototype.stringify = (script, params) ->
  if arguments.length is 1
    params = script
    script = null
  argv = if script then [process.execPath, script] else []
  keys = {}
  stringify = (config) =>
    for option in config.options
      key = option.name
      keys[key] = true
      value = params[key]
      unless value?
        continue unless option.required
        throw new Error "Required option \"#{key}\"" 
      switch option.type
        when 'boolean'
          argv.push "--#{key}" if value
        when 'string', 'integer'
          argv.push "--#{key}"
          argv.push "#{value}"
    if config.main
      value = params[config.main.name]
      throw new Error "Required main argument \"#{config.main.name}\"" if config.main.required and not value?
      keys[config.main.name] = value
      argv.push value if value?
  stringify @config
  if params[@config.action]
    config = @config.actions[params[@config.action]]
    throw new Error "Invalid action '#{params[@config.action]}'" unless config
    argv.push params[@config.action]
    keys[@config.action] = params[@config.action]
    stringify config
  # Check keys
  for key of params
    throw new Error "Invalid option '#{key}'" unless keys[key]
  argv

###

`help([action])`
----------------

Return a string describing the usage of the overall command or one of its action.

###
Parameters.prototype.help = (action) ->
    command = @config.actions[action]
    describeOption = (option) ->
      content = pad "      -#{option.shortcut} --#{option.name}", 26
      content += option.description
      content += '\n'
    describeCommand = (command) ->
      content = pad "    #{command.name}", 24
      content += command.description
      content += '\n'
      if command.options then for option in command.options
        content += describeOption option
      if command.main
        content += pad "      #{command.main.name}", 26
        content += command.main.description
        content += '\n'
      content
    if action and action isnt 'help'
      command = @config.actions[action]
      synopsis = @config.name + ' ' + action
      if command.options.length
        options = 'options...'
        options = "[#{options}]" unless (command.options.filter (o) -> o.required).length
        synopsis += " #{options}"
      if command.main
        main = "#{command.main.name}"
        main = "[#{main}]" unless command.main.required
        synopsis += " #{main}"
      content = """
      NAME
          #{@config.name} #{action} - #{command.description}
      SYNOPSIS
          #{synopsis}
      DESCRIPTION

      """
      content += describeCommand command
    else
      # Introduce the starstop command
      content = """
      NAME
          #{@config.name} - #{@config.description}

      """
      content += 'SYNOPSIS\n'
      content += "    #{@config.name}"
      content += ' action' if @config.actions.length
      content += ' [options...]'
      # content += ' command' if @config.main or @config.actions.filter((el) -> el.main).length
      content += '\n'
      if @config.actions.length
        content += '    where action is one of'
        content += '\n'
      for action in @config.actions
        content += pad "      #{action.name}", 24
        content += action.description
        content += '\n'
      content += 'DESCRIPTION\n'
      # Describe each option
      # content += describeCommand action
      for option in @config.options
        content += pad "    -#{option.shortcut} --#{option.name}", 24
        content += option.description
        content += '\n'
      if @config.main
        content += pad "    #{@config.main.name}", 24
        content += @config.main.description
        content += '\n'
      # Describe each action
      for action in @config.actions
        content += describeCommand action
      # Add examples
      content += 'EXAMPLES\n'
      if @config.actions.length
        content += "    #{@config.name} help       Show this message"
      else
        content += "    #{@config.name} --help     Show this message"
      content += '\n'
      # for action of @config.actions
      #   content += "    #{@config.name} help #{action}    Describe the #{action} action"
      # content += '\n'
      content

module.exports = (config) ->
  new Parameters config
module.exports.Parameters = Parameters




