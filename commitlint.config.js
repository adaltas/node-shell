// import scopes from "@commitlint/config-lerna-scopes";
import fs from "node:fs/promises";
import { glob } from "glob";
const pkg = await fs
  .readFile("./package.json", { encoding: "utf8" })
  .then((data) => JSON.parse(data));

const packages = await glob(
  pkg.workspaces.map((pattern) => `${pattern}/package.json`),
).then((files) =>
  Promise.all(
    files.map((file) =>
      fs
        .readFile(file, { encoding: "utf8" })
        .then((data) => JSON.parse(data))
        .then((pkg) => pkg.name.replace("@nikitajs/", "")),
    ),
  ),
);

export default {
  extends: ["@commitlint/config-conventional"],
  rules: {
    "scope-enum": async () => [
      2,
      "always",
      [
        // ...(await scopes.utils.getPackages(ctx)),
        ...packages,
        // Custom scopes
        "website",
        "release",
        "router",
        "help",
      ],
    ],
  },
};
