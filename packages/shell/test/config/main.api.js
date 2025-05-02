import { shell } from "../../lib/index.js";

describe("config.main.api", function () {
  describe("get", function () {
    it("for application", function () {
      shell({
        options: {
          config: {},
        },
        main: "leftover",
      })
        .config()
        .main.get()
        .should.eql({
          name: "leftover",
        });
    });

    it("for a command", function () {
      shell({
        commands: {
          app: {
            commands: {
              server: {
                main: "leftover",
              },
            },
          },
        },
      })
        .config(["app", "server"])
        .main.get()
        .should.eql({
          name: "leftover",
        });
    });
  });

  describe("set", function () {
    it("for application", function () {
      shell({}).config().main.set("leftover").get().should.eql({
        name: "leftover",
      });
    });
  });
});
