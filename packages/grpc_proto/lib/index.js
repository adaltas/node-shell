
const protoLoader = require('@grpc/proto-loader');

module.exports = {
  resolve: function() {
    return require.resolve('./shell.proto');
  },
  load: function(proto) {
    if (proto == null) {
      proto = module.exports.resolve();
    }
    return protoLoader.load(proto, {
      keepCase: true,
      longs: String,
      enums: String,
      defaults: true,
      oneofs: true
    });
  },
  loadSync: function(proto) {
    if (proto == null) {
      proto = module.exports.resolve();
    }
    return protoLoader.loadSync(proto, {
      keepCase: true,
      longs: String,
      enums: String,
      defaults: true,
      oneofs: true
    });
  }
};
