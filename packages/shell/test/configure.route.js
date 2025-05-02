import { shell } from "../lib/index.js";

describe("configure.route", function () {
  describe("validation", function () {
    it("accept function", function () {
      shell({
        handler: function () {},
      });

      shell({
        commands: {
          server: {
            handler: function () {},
          },
        },
      });
    });

    it("accept string", function () {
      // In application
      shell({
        handler: "path/to/module",
      });

      shell({
        commands: {
          server: {
            handler: "path/to/module",
          },
        },
      });
    });

    it("throw error if not valid in application", function () {
      (function () {
        shell({
          handler: {},
        });
      }).should.throw(
        "Invalid Route Configuration: accept string or function in application, got {}",
      );
    });

    it("throw error if not valid in command", function () {
      (function () {
        shell({
          commands: {
            server: {
              handler: {},
            },
          },
        });
      }).should.throw(
        'Invalid Route Configuration: accept string or function in command "server", got {}',
      );
    });
  });
});
