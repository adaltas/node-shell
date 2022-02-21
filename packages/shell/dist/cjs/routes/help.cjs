'use strict';

// Route Help
// Print the help information to stderr.

function help({argv, params, error, stderr, stderr_end}) {
  const command = this.helping(params);
  if (error) {
    stderr.write(`\n${error.message}\n`);
  }
  stderr.write(this.help(command));
  if (stderr_end) {
    stderr.end();
  }
  return null;
}

module.exports = help;
