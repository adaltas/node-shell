import dedent from "dedent";
import { shell } from "../../lib/index.js";

describe("help/help", function () {
  describe("without command", function () {
    it("minimalist, no name, no description, no options, no main", function () {
      shell({}).help().trim().should.eql(dedent`
        NAME
          myapp - No description yet

        SYNOPSIS
          myapp

        OPTIONS
          -h --help                 Display help information

        EXAMPLES
          myapp --help              Show this message
        `);
    });

    it("print without a name and a description", function () {
      shell().help().trim().should.eql(dedent`
        NAME
          myapp - No description yet

        SYNOPSIS
          myapp

        OPTIONS
          -h --help                 Display help information

        EXAMPLES
          myapp --help              Show this message
        `);
    });

    it("print multiple options", function () {
      shell({
        name: "myscript",
        description: "Some description for myscript",
        main: {
          name: "command",
          description: "Command in start",
        },
        options: {
          string: {
            shortcut: "s",
            description: "String option in start",
          },
          boolean: {
            shortcut: "b",
            type: "boolean",
            description: "Boolean option in start",
          },
          integer: {
            shortcut: "i",
            type: "integer",
            description: "Integer option in start",
          },
        },
      })
        .help()
        .trim().should.eql(dedent`
        NAME
          myscript - Some description for myscript

        SYNOPSIS
          myscript [myscript options] {command}

        OPTIONS
             command                Command in start
          -b --boolean              Boolean option in start
          -h --help                 Display help information
          -i --integer              Integer option in start
          -s --string               String option in start

        EXAMPLES
          myscript --help           Show this message
        `);
    });

    it("bypass required", function () {
      const app = shell({
        name: "myscript",
        description: "Some description for myscript.",
        options: {
          myarg: {
            description: "My argument.",
            required: true,
          },
        },
      });
      app.parse(["--help"]).help.should.be.true;
      app.help().trim().should.eql(dedent`
        NAME
          myscript - Some description for myscript.

        SYNOPSIS
          myscript [myscript options]

        OPTIONS
          -h --help                 Display help information
             --myarg                My argument. Required.

        EXAMPLES
          myscript --help           Show this message
        `);
    });
  });

  describe("with command", function () {
    it("error if command isnt defined", function () {
      (function () {
        shell({
          name: "myscript",
          commands: {},
        }).help("invalid");
      }).should.throw(
        'Invalid Command: argument "invalid" is not a valid command',
      );
    });

    it("minimalist, no name, no description, no options, no main", function () {
      shell({
        commands: {
          start: {},
        },
      })
        .help()
        .trim().should.eql(dedent`
        NAME
          myapp - No description yet

        SYNOPSIS
          myapp <command>

        OPTIONS
          -h --help                 Display help information

        COMMANDS
          start                     No description yet for the start command
          help                      Display help information

        EXAMPLES
          myapp --help              Show this message
          myapp help                Show this message
        `);
    });

    it("print all commands with multiple options", function () {
      shell({
        name: "myscript",
        description: "Some description for myscript",
        commands: {
          start: {
            description: "Description for the start command",
            main: {
              name: "leftover",
              description: "Command in start",
            },
            options: {
              string: {
                shortcut: "s",
                description: "String option in start",
              },
              boolean: {
                shortcut: "b",
                type: "boolean",
                description: "Boolean option in start",
              },
              integer: {
                shortcut: "i",
                type: "integer",
                description: "Integer option in start",
              },
            },
          },
          stop: {
            description: "Description for the stop command",
            main: {
              name: "leftover",
              description: "Command in stop",
            },
            options: {
              array: {
                shortcut: "a",
                description: "Array option in stop",
              },
            },
          },
        },
      })
        .help()
        .trim().should.eql(dedent`
        NAME
          myscript - Some description for myscript

        SYNOPSIS
          myscript <command>

        OPTIONS
          -h --help                 Display help information

        COMMANDS
          start                     Description for the start command
          stop                      Description for the stop command
          help                      Display help information

        EXAMPLES
          myscript --help           Show this message
          myscript help             Show this message
        `);
    });

    it("describe a specific command", function () {
      const app = shell({
        name: "myscript",
        description: "Some description for myscript",
        commands: {
          start: {
            description: "Description for the start command",
            main: {
              name: "leftover",
              description: "Command in start",
            },
            options: {
              string: {
                shortcut: "s",
                description: "String option in start",
              },
            },
          },
        },
      });
      const expect = dedent`
        NAME
          myscript start - Description for the start command

        SYNOPSIS
          myscript start [start options] {leftover}

        OPTIONS for start
             leftover               Command in start
          -h --help                 Display help information
          -s --string               String option in start

        OPTIONS for myscript
          -h --help                 Display help information

        EXAMPLES
          myscript start --help     Show this message
        `;
      app.help("start").trim().should.eql(expect);
      app.help(["start"]).trim().should.eql(expect);
    });
  });

  describe("with nested command", function () {
    it("error if command isnt defined", function () {
      (function () {
        shell({
          name: "myscript",
          commands: {
            mycommand: {},
          },
        }).help(["mycommand", "invalid"]);
      }).should.throw(
        'Invalid Command: argument "mycommand invalid" is not a valid command',
      );
    });
  });

  describe("name", function () {
    it("display help of the app", function () {
      // With an options
      shell()
        .help()
        .should.match(/myapp - No description yet/);
    });

    it("display help of a command with --help option", function () {
      // With an options
      shell({
        commands: {
          start: {},
        },
      })
        .help(["start"])
        .should.match(/myapp start - No description yet/);
    });
  });
});
