
const path = require('path');

module.exports = function(module) {
  module = module.substr(0, 1) === '.' ? path.resolve(process.cwd(), module) : module;
  return require.main.require(module);
};
