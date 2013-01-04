
path = require 'path'
pad = require 'pad' 

Parameters = (@config = {}) ->
  @bynames = {}
  # An object where key are action and values are object map between shortcuts and names
  @shortcuts = {}
  # An object where key are action and values are list of options
  @requireds = {}
  for action, command of @config
    main = command.main
    @bynames[action] = {}
    @shortcuts[action] = {}
    # For each action, store the required fields as an array
    @requireds[action] = []
    @bynames[action][main.name] = main if main
    @requireds[action].push main.name if main?.required
    if command.options then for option in command.options
      option.type ?= 'string'
      @bynames[action][option.name] = option
      @shortcuts[action][option.shortcut] = option.name
      @requireds[action].push option.name if option.required
  @

###

`decode([argv])`
----------------

Convert process arguments into a usable object. Argument may
be in the form of a string or an array. If not provided, it default
to `process.argv`.

Example

  options = argv.decode ['node', 'startstop', 'start', '--watch', __dirname, '-s', 'my', '--command']
  options.should.eql
    action: 'start'
    watch: __dirname
    strict: true
    command: 'my --command'

###
Parameters.prototype.decode = (argv = process.argv) ->
  argv = argv.split ' ' if typeof argv is 'string'
  argv.shift() and argv.shift()
  data = {}
  data.action = argv.shift()
  data.action ?= 'help'
  command = @config[data.action]
  throw new Error "Invalid action '#{data.action}'" unless command
  while true
    break if not argv.length or argv[0].substr(0, 1) isnt '-'
    key = argv.shift()
    shortcut = key.substr(1, 1) isnt '-'
    key = key.substring (if shortcut then 1 else 2), key.length
    key = @shortcuts[data.action][key] if shortcut
    option = @bynames[data.action][key]
    throw new Error "Invalid option '#{key}'" unless option
    switch option.type
      when 'boolean'
        value = true
      when 'string'
        value = argv.shift()
    data[key] = value
  # Store the full command in the return object
  data.command = argv.join(' ') if argv.length
  # Time to check against required arguments
  for name, options of @bynames[data.action]
    if options.required
      throw new Error "Required main argument \"#{name}\"" unless data[name]?
    data[name] ?= null
  # for name in @requireds[data.action]
  #   throw new Error "Main argument \"#{name}\" is required" unless data[name]?
  data

###

`encode([script], data)`
------------------------

Convert an object into process arguments.

###
Parameters.prototype.encode = (script, data) ->
  if arguments.length is 1
    data = script
    script = null
  command = @config[data.action]
  throw new Error "Invalid action '#{data.action}'" unless command
  argv = if script then [process.execPath, script] else []
  argv.push data.action
  for key, value of data
    continue if key is 'action' or key is command.main?.name
    option = @bynames[data.action][key]
    throw new Error "Invalid option '#{key}'" unless option
    switch option.type
      when 'boolean'
        argv.push "--#{key}" if value
      when 'string'
        argv.push "--#{key}"
        argv.push value
  if command.main
    value = data[command.main.name]
    throw new Error "Required main argument \"#{command.main.name}\"" if command.main.required and not value?
    argv.push value if value?
  argv

module.exports = (config) ->
  new Parameters config
module.exports.Parameters = Parameters




