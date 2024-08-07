import path from 'node:path';
import protoLoader from '@grpc/proto-loader';
import { utils } from 'shell';

// Dependencies
const { __dirname } = utils.filedirname(import.meta.url);

var index = {
  resolve: function () {
    return path.resolve(__dirname, "./shell.proto");
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

export { index as default };
