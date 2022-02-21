'use strict';

var fs = require('node:fs');
var protobuf = require('protobufjs');
var proto = require('@shell-js/grpc_proto');

function _interopDefaultLegacy (e) { return e && typeof e === 'object' && 'default' in e ? e : { 'default': e }; }

var fs__default = /*#__PURE__*/_interopDefaultLegacy(fs);
var protobuf__default = /*#__PURE__*/_interopDefaultLegacy(protobuf);
var proto__default = /*#__PURE__*/_interopDefaultLegacy(proto);

// ## Source code
function shell_protobuf({argv, params, config, error, stdout, stdout_end}) {
  const proto_path = proto__default["default"].resolve();
  switch (params.format) {
    case 'json':
      return protobuf__default["default"].load(proto_path, function(err, root) {
        if (err) {
          return reject(err);
        }
        stdout.write(JSON.stringify(root.toJSON(), null, 2));
        if (stdout_end) {
          return stdout.end();
        }
      });
    case 'proto':
      return fs__default["default"].readFile(proto_path, function(err, data) {
        if (err) {
          return reject(err);
        }
        stdout.write(data);
        if (stdout_end) {
          return stdout.end();
        }
      });
    default:
      // TODO: more explicit error message
      throw error(["Invalid Format"]);
  }
}

module.exports = shell_protobuf;
