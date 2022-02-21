
// Route Help
// Print the help information to stderr.

export default function({argv, params, error, stderr, stderr_end}) {
  const command = this.helping(params);
  if (error) {
    stderr.write(`\n${error.message}\n`);
  }
  stderr.write(this.help(command));
  if (stderr_end) {
    stderr.end();
  }
  return null;
};
