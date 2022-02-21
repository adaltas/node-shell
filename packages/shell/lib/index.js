
// # Shell.js
// Usage: `shell(config)`

import Shell from './Shell.js';
import './plugins/router.js';
import './plugins/config.js';
import './plugins/args.js';
import './plugins/help.js';

const shell = function(config) {
  return new Shell(config);
};

export {shell, Shell};
export * as utils from './utils/index.js'
