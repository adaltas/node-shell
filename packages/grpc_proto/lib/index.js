
// Dependencies
import path from 'node:path';
import protoLoader from '@grpc/proto-loader';
import {utils} from 'shell';
const {__dirname} = utils.filedirname(import.meta.url);

export default {
  resolve: function() {
    return path.resolve(__dirname, './shell.proto');
  },
  load: function(proto) {
    if (proto == null) {
      proto = this.resolve();
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
      proto = this.resolve();
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
