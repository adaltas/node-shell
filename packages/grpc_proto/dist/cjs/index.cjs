'use strict';

var path = require('node:path');
var protoLoader = require('@grpc/proto-loader');
var shell = require('shell');

function _interopDefaultLegacy (e) { return e && typeof e === 'object' && 'default' in e ? e : { 'default': e }; }

var path__default = /*#__PURE__*/_interopDefaultLegacy(path);
var protoLoader__default = /*#__PURE__*/_interopDefaultLegacy(protoLoader);

const {__dirname: __dirname$1} = shell.utils.filedirname((typeof document === 'undefined' ? new (require('u' + 'rl').URL)('file:' + __filename).href : (document.currentScript && document.currentScript.src || new URL('index.cjs', document.baseURI).href)));

var index = {
  resolve: function() {
    return path__default["default"].resolve(__dirname$1, './shell.proto');
  },
  load: function(proto) {
    if (proto == null) {
      proto = this.resolve();
    }
    return protoLoader__default["default"].load(proto, {
      keepCase: true,
      longs: String,
      enums: String,
      defaults: true,
      oneofs: true
    });
  },
  loadSync: function(proto) {
    if (proto == null) {
      proto = this.resolve();
    }
    return protoLoader__default["default"].loadSync(proto, {
      keepCase: true,
      longs: String,
      enums: String,
      defaults: true,
      oneofs: true
    });
  }
};

module.exports = index;
