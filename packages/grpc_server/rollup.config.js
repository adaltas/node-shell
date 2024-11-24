export default [
  {
    input: "lib/index.js",
    output: [
      {
        file: `dist/cjs/index.cjs`,
        format: "cjs",
      },
      {
        file: `dist/esm/index.js`,
        format: "esm",
      },
    ],
    external: [
      "mixme",
      "node:stream",
      "shell",
      "@grpc/grpc-js",
      "@shell-js/grpc_proto",
    ],
  },
  {
    input: "lib/routes/shell_protobuf.js",
    output: [
      {
        exports: "default",
        file: `dist/cjs/routes/shell_protobuf.js`,
        format: "cjs",
      },
      {
        exports: "default",
        file: `dist/esm/routes/shell_protobuf.js`,
        format: "esm",
      },
    ],
    external: ["protobufjs", "node:fs", "@shell-js/grpc_proto"],
  },
];
