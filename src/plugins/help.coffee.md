
## Plugin "help"

    # Dependecies
    path = require 'path'
    # Parameters & plugins
    Parameters = require '../Parameters'
    {merge} = require 'mixme'
    require '../plugins/config'

    Parameters::init = ( (parent) ->
      ->
        @register configure_app_set: ({config, command}, handler) ->
          config.commands ?= {}
          # No "help" option for command "help"
          if not command.length or not config.help
            config.options ?= {}
            config.options['help'] = merge config.options['help'],
              name: 'help'
              cascade: true
              shortcut: 'h'
              description: 'Display help information'
              type: 'boolean'
              help: true
          if not command.length and Object.keys(config.commands).length
            command =
              name: 'help'
              description: "Display help information"
              main:
                name: 'name'
                description: 'Help about a specific command'
              help: true
              route: path.resolve __dirname, '../routes/help' # config.help.route
              options:
                'help': disabled: true
            config.commands[command.name] = merge command, config.commands[command.name]
          ->
            handler.call @, arguments...
            config.description ?= "No description yet for the #{config.name} command"
        @register configure_commands_set: ({config, command}, handler) ->
          ->
            handler.call @, arguments...
            config.description ?= "No description yet for the #{config.name} command"
        parent.call @, arguments...
    )(Parameters::init)
