import should from "should";
import { shell } from "../../lib/index.js";

describe("help/helping", function () {
  describe("help is not requested", function () {
    it("help command only in extended mode", function () {
      const helping = shell({
        commands: {
          start: {},
        },
        extended: true,
      }).helping([{}]);
      (helping === null).should.be.true();
    });
  });

  describe("command help not followed by a command", function () {
    it("in flatten mode", function () {
      shell({
        commands: {
          start: {},
        },
      })
        .helping({
          command: ["help"],
        })
        .should.eql([]);
    });

    it("in extended mode", function () {
      shell({
        commands: {
          start: {},
        },
        extended: true,
      })
        .helping([
          {},
          {
            command: "help",
          },
        ])
        .should.eql([]);
    });
  });

  describe("command help followed by a command name", function () {
    it("in flatten mode", function () {
      shell({
        commands: {
          start: {
            commands: {
              server: {},
            },
          },
        },
      })
        .helping({
          command: ["help"],
          name: ["start"],
        })
        .should.eql(["start"]);
    });

    it("in extended mode", function () {
      shell({
        commands: {
          start: {
            commands: {
              server: {},
            },
          },
        },
        extended: true,
      })
        .helping([
          {},
          {
            command: "help",
            name: ["start"],
          },
        ])
        .should.eql(["start"]);
    });
  });

  describe("option in application level", function () {
    it("no help option in flatten mode", function () {
      should.not.exist(
        shell({}).helping({
          my_opt: true,
        }),
      );
    });

    it("no help option in extended mode", function () {
      should.not.exist(shell({ extended: true }).helping([{ my_opt: true }]));
    });

    it("in flatten mode", function () {
      shell({})
        .helping({
          help: true,
        })
        .should.eql([]);
    });

    it("in extended mode", function () {
      shell({ extended: true })
        .helping([{ help: true }])
        .should.eql([]);
    });
  });

  describe("option in command level", function () {
    it("no help option in flatten mode", function () {
      should.not.exist(
        shell({
          commands: {
            server: {
              options: {
                my_opt_1: {},
              },
              commands: {
                start: {
                  options: {
                    my_opt_2: {},
                  },
                  commands: {
                    app: {},
                  },
                },
              },
            },
          },
        }).helping({
          command: ["server", "start"],
          my_opt_1: true,
          my_opt_2: true,
        }),
      );
    });

    it("no help option in extended mode", function () {
      should.not.exist(
        shell({
          commands: {
            server: {
              options: {
                my_opt_1: {},
              },
              commands: {
                start: {
                  options: {
                    my_opt_2: {},
                  },
                  commands: {
                    app: {},
                  },
                },
              },
            },
          },
          extended: true,
        }).helping([
          {},
          {
            command: "server",
            my_opt_1: true,
          },
          {
            command: "start",
            my_opt_2: true,
          },
        ]),
      );
    });

    it("with help options in the middle of subcommand in flatten mode", function () {
      shell({
        commands: {
          server: {
            commands: {
              start: {},
            },
          },
        },
      })
        .helping({
          command: ["server"],
          help: true,
        })
        .should.eql(["server"]);
    });

    it("with help options in the middle of subcommand in extended mode", function () {
      shell({
        commands: {
          server: {
            commands: {
              start: {},
            },
          },
        },
        extended: true,
      })
        .helping([
          {},
          {
            command: "server",
            help: true,
          },
        ])
        .should.eql(["server"]);
    });

    it("throw Error if help in not associated with the last command in extended mode", function () {
      (function () {
        shell({
          commands: {
            server: {
              commands: {
                start: {},
              },
            },
          },
          extended: true,
        }).helping([
          {},
          {
            command: "server",
            help: true,
          },
          {
            command: "start",
          },
        ]);
      }).should.throw(
        "Invalid Argument: `help` must be associated with a leaf command",
      );
    });

    it("with help options at the end of subcommand in flatten mode", function () {
      shell({
        commands: {
          server: {
            commands: {
              start: {},
            },
          },
        },
      })
        .helping({
          command: ["server", "start"],
          help: true,
        })
        .should.eql(["server", "start"]);
    });

    it("with help options at the end of subcommand in extended mode", function () {
      shell({
        commands: {
          server: {
            commands: {
              start: {},
            },
          },
        },
        extended: true,
      })
        .helping([
          {},
          {
            command: "server",
          },
          {
            command: "start",
            help: true,
          },
        ])
        .should.eql(["server", "start"]);
    });
  });
});
