
var parameters = require('..');
require('should');

// NAME
//     server - Manage a web server
// SYNOPSIS
//     server action [options...]
//     where action is one of
//       start             Start a web server
//       help              Display help information about server
// DESCRIPTION
//     start               Start a web server
//       -h --host           Web server listen host
//       -p --port           Web server listen port
//     help                Display help information about server
//       command             Help about a specific action
// EXAMPLES
//     server help       Show this message

command = parameters({
  name: 'server',
  description: 'Manage a web server',
  actions: [{
    name: 'start',
    description: 'Start a web server',
    options: [{
      name: 'host', shortcut: 'h', 
      description: 'Web server listen host'
    },{
      name: 'port', shortcut: 'p', type: 'integer', 
      description: 'Web server listen port'
    }]
  }]
});
// Print help
console.log( command.help() );
// Extract command arguments
command.decode(
  ['node', 'server.js', 'start', '--host', '127.0.0.1', '-p', '80']
).should.eql({
  action: 'start',
  host: '127.0.0.1',
  port: 80
});
// Create a command
command.encode({
  action: 'start',
  host: '127.0.0.1',
  port: 80
}).should.eql(
  ['start', '--host', '127.0.0.1', '--port', '80']
);
