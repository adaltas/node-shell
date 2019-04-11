
# Route Help

Print the help to stderr.

## Source code

    module.exports = ({argv, params, config, error}) ->
      command = @helping params
      writer = config.help.writer
      if typeof writer is 'string' then switch writer
        when 'stdout' then writer = process.stdout
        when 'stderr' then writer = process.stderr
      writer.write "\n#{error.message}\n" if error
      writer.write @help command
      writer.end() if config.help.end
