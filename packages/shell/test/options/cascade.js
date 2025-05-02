import { shell } from "../../lib/index.js";

describe("options.cascade", function () {
  it("from root with unlimited level", function () {
    const app = shell({
      options: {
        opt: { cascade: true },
      },
      commands: {
        server: {
          commands: {
            start: {},
          },
        },
      },
    });
    app
      .config()
      .get()
      .commands.server.commands.start.options.opt.transient.should.eql(true);
    app.config(["server", "start"]).options("opt").get().should.eql({
      cascade: true,
      name: "opt",
      type: "string",
      transient: true,
    });
  });

  it("from command with unlimited level", function () {
    const app = shell({
      commands: {
        server: {
          options: {
            opt: { cascade: true },
          },
          commands: {
            start: {},
          },
        },
      },
    });
    app.config(["server", "start"]).options("opt").get().should.eql({
      cascade: true,
      name: "opt",
      type: "string",
      transient: true,
    });
  });

  it("from root with limited level", function () {
    const app = shell({
      options: {
        opt: { cascade: 2 },
      },
      commands: {
        server: {
          commands: {
            start: {
              commands: {
                sth: {},
              },
            },
          },
        },
      },
    });
    app.config(["server"]).options.list().should.eql(["help", "opt"]);
    app.config(["server", "start"]).options.list().should.eql(["help", "opt"]);
    app.config(["server", "start", "sth"]).options.list().should.eql(["help"]);
  });

  it("from command with limited level", function () {
    const app = shell({
      commands: {
        server: {
          options: {
            opt: { cascade: 2 },
          },
          commands: {
            start: {
              commands: {
                sth: {
                  commands: {
                    else: {},
                  },
                },
              },
            },
          },
        },
      },
    });
    app.config().options.list().should.eql(["help"]);
    app.config(["server", "start"]).options.list().should.eql(["help", "opt"]);
    app
      .config(["server", "start", "sth"])
      .options.list()
      .should.eql(["help", "opt"]);
    app
      .config(["server", "start", "sth", "else"])
      .options.list()
      .should.eql(["help"]);
  });
});
