
## Integration

### Standard command line example

```javascript
require('should')
require('parameters')({
  name: 'server',
  options: [{
    name: 'host', shortcut: 'h'
  },{
    name: 'port', shortcut: 'p', type: 'integer'
  }]
});
// Convert a literal object into a shell command
.stringify({
  host: '127.0.0.1',
  port: 80
}).should.eql(
  ['--host', '127.0.0.1', '--port', '80']
);
```

### Command-based command line example

```javascript
require('should')
require('parameters')({
  name: 'server',
  commands: [{
    name: 'start',
    options: [{
      name: 'host', shortcut: 'h'
    },{
      name: 'port', shortcut: 'p', type: 'integer'
    }]
  }]
});
// Convert a literal object into a shell command
.stringify({
  command: ['start'],
  host: '127.0.0.1',
  port: 80
}).should.eql(
  ['start', '--host', '127.0.0.1', '--port', '80']
);
```
