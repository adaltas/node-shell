
path = require 'path'

module.exports = (module) ->
  module = if module.substr(0, 1) is '.'
  then path.resolve process.cwd(), module
  else module
  require.main.require module
