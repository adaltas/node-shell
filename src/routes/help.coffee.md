
# Route Help

Print the help to stderr.

## Source code

    module.exports = ({argv, params, error}) ->
      command = @helping params
      config = @confx().get()
      writer = config.router.writer
      if typeof writer is 'string' then switch writer
        when 'stdout' then writer = process.stdout
        when 'stderr' then writer = process.stderr
      writer.write "\n#{error.message}\n" if error
      writer.write @help command
      writer.end() if config.router.end
