import { shell } from "shell";

export default shell({
  name: "server",
  description: "Manage a web server",
  commands: {
    start: {
      description: "Start a web server",
      options: {
        host: { shortcut: "h", description: "Web server listen host" },
        port: {
          shortcut: "p",
          type: "integer",
          description: "Web server listen port",
        },
      },
    },
  },
});
