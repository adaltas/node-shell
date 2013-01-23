[![Build Status](https://secure.travis-ci.org/wdavidw/node-parameters.png)](http://travis-ci.org/wdavidw/node-parameters)

<pre>
                 _                                               _                
                | |                                             | |               
 _ __   ___   __| | ___     _ __   __ _ _ __ __ _ _ __ ___   ___| |_ ___ _ __ ___ 
| '_ \ / _ \ / _` |/ _ \   | '_ \ / _` | '__/ _` | '_ ` _ \ / _ \ __/ _ \ '__/ __|
| | | | (_) | (_| |  __/   | |_) | (_| | | | (_| | | | | | |  __/ ||  __/ |  \__ \
|_| |_|\___/ \__,_|\___|   | .__/ \__,_|_|  \__,_|_| |_| |_|\___|\__\___|_|  |___/
                           | |                                                    
                           |_| 

</pre>

Node parameters is sugar for parsing typical unix command line options. 

*   Standard and actions-based command lines (think `git pull ...`)
*   Asymetric: parse and stringify
*   Complete tests and samples

Standard command line example
-----------------------------

```javascript
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
```

Action-based command line example
---------------------------------

```javascript
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
```

Development
-----------

Tests are executed with mocha. To install it, simple run `npm install`, it will install
mocha and its dependencies in your project "node_modules" directory.

To run the tests:
```bash
npm test
```

The tests run against the CoffeeScript source files.

To generate the JavaScript files:
```bash
make build
```

The test suite is run online with [Travis][travis] against Node.js version 0.6, 0.7, 0.8 and 0.9.

Contributors
------------

*   David Worms: <https://github.com/wdavidw>
