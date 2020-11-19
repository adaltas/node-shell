
# Route Help

Print the help to stderr.

## Source code

    module.exports = ({argv, params, error, stderr, stderr_end}) ->
      command = @helping params
      stderr.write "\n#{error.message}\n" if error
      stderr.write @help command
      stderr.end() if stderr_end
      null
