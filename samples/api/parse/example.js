
import 'should';
import {shell} from "shell";

shell({
  name: "server",
  description: "Manage a web server",
  options: {
    "config": { shortcut: "c" } },
  commands: {
    "start": {
      description: "Start a web server",
      options: {
        "host": {
          shortcut: "h",
          description: "Web server listen host" },
        "port": {
          shortcut: "p",
          type: "integer",
          description: "Web server listen port" } } } } })
