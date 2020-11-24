
# Shell.js

Usage: `shell(config)`

    Shell = require './Shell'
    require './plugins/router'
    require './plugins/config'
    require './plugins/args'
    require './plugins/help'

    module.exports = (config) ->
      new Shell config
