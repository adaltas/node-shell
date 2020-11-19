
const parameters = require('./packages/parameters');

// NAME
//     precious - Manage your precious
// 
// SYNOPSIS
//     precious <command>
// 
// OPTIONS
//     -h --help               Display help information
// 
// COMMANDS
//     secrets                 No description yet for the secrets command
//     help                    Display help information about precious
// 
// EXAMPLES
//     precious --help         Show this message
//     precious help           Show this message

const params = parameters({
  name: 'precious',
  description: 'Manage your precious',
  commands: {
    "secrets": {
      options: {
        database: {
          shortcut: "d",
          description: "Where to store your secrets"
        }
      },
      commands: {
        "set": {
          options: {
            key: {
              shortcut: 'h'
            },
            value: {
              shortcut: "v"
} } } } } } });

const args = params.parse()
if(commands = params.helping(args)){
  process.stdout.write(params.help(commands))
}
