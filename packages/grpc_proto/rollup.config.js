
import copy from 'rollup-plugin-copy'

export default [{
  input: 'lib/index.js',
  output: [
    {
      exports: 'default',
      file: `dist/cjs/index.cjs`,
      format: 'cjs'
    }, {
      exports: 'default',
      file: `dist/esm/index.js`,
      format: 'esm'
    },
  ],
  external: ['mixme', 'node:path', '@grpc/proto-loader', 'shell'],
  plugins: [
    copy({
      targets: [
        { src: 'lib/shell.proto', dest: 'dist/cjs/' },
        { src: 'lib/shell.proto', dest: 'dist/esm/' }
      ]
    })
  ]
}];
