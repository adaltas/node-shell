
{mutate, is_object_literal} = require 'mixme'

###
Format errors
###

module.exports = ->
  arguments[0] = message: arguments[0] if typeof arguments[0] is 'string'
  arguments[0] = message: arguments[0] if Array.isArray arguments[0]
  options = {}
  for arg in arguments
    throw Error "Invalid Error Argument: expect an object literal, got #{JSON.stringify arg}." unless is_object_literal arg
    mutate options, arg
  options.message = options.message.filter((i)->i).join ' ' if Array.isArray options.message
  error = new Error options.message
  error.command = options.command if options.command
  error
  
