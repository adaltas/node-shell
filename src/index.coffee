
path = require 'path'
pad = require 'pad' 

Parameters = (@config = {}) ->
  # Sanitize options
  options = (action) ->
    for option in action.options
      # Access option by key
      do (option) ->
        action.options.__defineGetter__ option.name, -> option
      option.type ?= 'string'
      action.shortcuts[option.shortcut] = option.name
  # An object where key are action and values are object map between shortcuts and names
  config.shortcuts = {}
  config.options ?= []
  options config
  config.actions ?= []
  config.actions = [config.actions] unless Array.isArray config.actions
  for action in config.actions
    # Access action by key
    do (action) =>
      config.actions.__defineGetter__ action.name, -> action
    main = action.main
    action.shortcuts = {}
    action.options ?= []
    action.options = [action.options] unless Array.isArray action.options
    options action
  unless config.actions.help
    if config.actions.length
      config.actions.push 
        name: 'help'
        description: "Display help information about #{config.name}"
        main:
          name: 'command'
          description: 'Help about a specific action'
    else 
      config.options.push 
        name: 'help'
        shortcut: 'h'
        description: "Display help information"
  @

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
      SYNOPSIS
          #{@config.name} action [options...]
          where action is one of

      """
      for action in @config.actions
        content += pad "      #{action.name}", 24
        content += action.description
        content += '\n'
      content += """
      DESCRIPTION

      """
      # Describe each action
      for action in @config.actions
        content += describeCommand action
      # Add examples
      content += """
      EXAMPLES
          #{@config.name} help          Show this message
      """
      # for action of @config.actions
      #   content += "    #{@config.name} help #{action}    Describe the #{action} action"
      content += '\n'
      content

###

`decode([argv])`
----------------

Convert process arguments into a usable object. Argument may
be in the form of a string or an array. If not provided, it default
to `process.argv`.

Example

  params = argv.decode ['node', 'startstop', 'start', '--watch', __dirname, '-s', 'my', '--command']
  params.should.eql
    action: 'start'
    watch: __dirname
    strict: true
    command: 'my --command'

###
Parameters.prototype.decode = (argv = process.argv) ->
  argv = argv.split ' ' if typeof argv is 'string'
  # Remove node and script argv elements
  argv.shift() and argv.shift()
  # Extracted parameters
  params = {}
  decode = (action, argv) ->
    while true
      break if not argv.length or argv[0].substr(0, 1) isnt '-'
      key = argv.shift()
      shortcut = key.substr(1, 1) isnt '-'
      key = key.substring (if shortcut then 1 else 2), key.length
      key = action.shortcuts[key] if shortcut
      option = action.options?[key]
      throw new Error "Invalid option '#{key}'" unless option
      switch option.type
        when 'boolean'
          value = true
        when 'string'
          value = argv.shift()
      params[key] = value
    # Store the full command in the return object
    params.command = argv.join(' ') if argv.length
    # Check against required options
    options = action.options
    if options then for option in options
      if option.required
        throw new Error "Required argument \"#{option.name}\"" unless params[option.name]?
      # params[option.name] ?= null
    # Check against required main
    main = action.main
    if main
      if main.required
        throw new Error "Required main argument \"#{main.name}\"" unless params[main.name]?
      # params[main.name] ?= null
    params
  # If they are action (other than help) and first arg is an action 
  if @config.actions.length and argv.length is 0
    argv.push 'help'
  if @config.actions.length and argv[0].substr(0,1) isnt '-'
    action = @config.actions[argv[0]]
    throw new Error "Invalid action '#{argv[0]}'" unless action
    params.action = argv.shift()
  else
    action = @config
  decode action, argv

###

`encode([script], params)`
------------------------

Convert an object into process arguments.

###
Parameters.prototype.encode = (script, params) ->
  if arguments.length is 1
    params = script
    script = null
  encode = (action, params) ->
    for key, value of params
      continue if key is 'action' or key is action.main?.name
      option = action.options?[key]
      throw new Error "Invalid option '#{key}'" unless option
      switch option.type
        when 'boolean'
          argv.push "--#{key}" if value
        when 'string'
          argv.push "--#{key}"
          argv.push value
    if action.main
      value = params[action.main.name]
      throw new Error "Required main argument \"#{action.main.name}\"" if action.main.required and not value?
      argv.push value if value?
    argv
  argv = if script then [process.execPath, script] else []
  if params.action
    action = @config.actions[params.action]
    throw new Error "Invalid action '#{params.action}'" unless action
    argv.push params.action
  else 
    action = @config
  encode action, params

module.exports = (config) ->
  new Parameters config
module.exports.Parameters = Parameters




