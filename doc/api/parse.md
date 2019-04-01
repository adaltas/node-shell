
## Integration

### Standard command line example

```javascript
require('should')
require('parameters')({
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
// Convert the command to a literal object
.parse(
  ['--host', '127.0.0.1', '-p', '80']
).should.eql({
  host: '127.0.0.1',
  port: 80
});
```

### Command-based command line example

```javascript
require('should')
require('parameters')({
  name: 'server',
  description: 'Manage a web server',
  commands: [{
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
// Convert the command to a literal object
.parse(
  ['start', '--host', '127.0.0.1', '-p', '80']
).should.eql({
  command: ['start'],
  host: '127.0.0.1',
  port: 80
});
```
