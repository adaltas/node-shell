
// # Shell.js
// Usage: `shell(config)`

const Shell = require('./Shell');
require('./plugins/router');
require('./plugins/config');
require('./plugins/args');
require('./plugins/help');

module.exports = function(config) {
  return new Shell(config);
};
