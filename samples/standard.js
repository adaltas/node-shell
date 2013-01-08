
var parameters = require('..');
require('should');

// NAME
//     server - Start a web server
// SYNOPSIS
//     server [options...]
// DESCRIPTION
//     -h --host           Web server listen host
//     -p --port           Web server listen port
//     -h --help           Display help information
// EXAMPLES
//     server --help     Show this message

command = parameters({
  name: 'server',
  description: 'Start a web server',
  options: [{
    name: 'host', shortcut: 'h', 
    description: 'Web server listen host'
  },{
    name: 'port', shortcut: 'p', type: 'integer', 
    description: 'Web server listen port'
  }]
});
// Print help
console.log( command.help() );
// Extract command arguments
command.decode(
  ['node', 'server.js', '--host', '127.0.0.1', '-p', '80']
).should.eql({
  host: '127.0.0.1',
  port: 80
});
// Create a command
command.encode({
  host: '127.0.0.1',
  port: 80
}).should.eql(
  ['--host', '127.0.0.1', '--port', '80']
);