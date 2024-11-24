'use strict';

var path = require('node:path');
var protoLoader = require('@grpc/proto-loader');
var shell = require('shell');

var _documentCurrentScript = typeof document !== 'undefined' ? document.currentScript : null;
// Dependencies
const { __dirname: __dirname$1 } = shell.utils.filedirname((typeof document === 'undefined' ? require('u' + 'rl').pathToFileURL(__filename).href : (_documentCurrentScript && _documentCurrentScript.tagName.toUpperCase() === 'SCRIPT' && _documentCurrentScript.src || new URL('index.cjs', document.baseURI).href)));

var index = {
  resolve: function () {
    return path.resolve(__dirname$1, "./shell.proto");
  },
  load: function (proto) {
    proto ??= this.resolve();
    return protoLoader.load(proto, {
      keepCase: true,
      longs: String,
      enums: String,
      defaults: true,
      oneofs: true,
    });
  },
  loadSync: function (proto) {
    proto ??= this.resolve();
    return protoLoader.loadSync(proto, {
      keepCase: true,
      longs: String,
      enums: String,
      defaults: true,
      oneofs: true,
    });
  },
};

module.exports = index;
