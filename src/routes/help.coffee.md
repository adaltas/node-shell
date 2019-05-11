
# Route Help

Print the help to stderr.

## Source code

    module.exports = ({argv, params, error, writer}) ->
      command = @helping params
      writer.write "\n#{error.message}\n" if error
      writer.write @help command
      writer.end()
      null
