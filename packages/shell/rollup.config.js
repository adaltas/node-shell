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
    external: ["mixme", "pad", "node:path", "node:stream", "node:url"],
  },
  {
    input: "lib/routes/help.js",
    output: [
      {
        exports: "default",
        file: `dist/cjs/routes/help.cjs`,
        format: "cjs",
      },
      {
        exports: "default",
        file: `dist/esm/routes/help.js`,
        format: "esm",
      },
    ],
    external: ["mixme", "pad", "node:path", "node:stream", "node:url"],
  },
];
