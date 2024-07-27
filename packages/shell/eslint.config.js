import globals from "globals";
import js from "@eslint/js";
import mocha from "eslint-plugin-mocha";
import prettier from "eslint-plugin-prettier/recommended";

export default [
  {
    ignores: ["dist/**"],
  },
  {
    languageOptions: { globals: { ...globals.node } },
    rules: {
      indent: [
        "error",
        2,
        {
          SwitchCase: 1,
        },
      ],
    },
  },
  js.configs.recommended,
  mocha.configs.flat.recommended,
  prettier,
];
