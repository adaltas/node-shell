import { shell } from "../../lib/index.js";

describe("config.options", function () {
  describe("validation", function () {
    it("enforce types at application level", function () {
      (function () {
        shell({
          options: {
            key: { type: "invalid" },
          },
        });
      }).should.throw(
        [
          "Invalid Option Configuration:",
          'supported options types are ["string","boolean","integer","array"],',
          'got "invalid" for option "key"',
        ].join(" "),
      );
    });

    it("enforce types at command level", function () {
      (function () {
        shell({
          commands: {
            server: {
              commands: {
                start: {
                  options: {
                    key: { type: "invalid" },
                  },
                },
              },
            },
          },
        });
      }).should.throw(
        [
          "Invalid Option Configuration:",
          'supported options types are ["string","boolean","integer","array"],',
          'got "invalid" for option "key" in command "server start"',
        ].join(" "),
      );
    });

    it("enforce enum", function () {
      (function () {
        shell({
          options: {
            key: { enum: true },
          },
        });
      }).should.throw(
        'Invalid Option Configuration: option property "enum" must be a string or an array, got true',
      );
    });
  });

  describe("collision", function () {
    it("dont detect collision in extended mode", function () {
      shell({
        extended: true,
        options: {
          collide: {},
        },
        commands: {
          start: {
            options: { collide: {} },
          },
        },
      });
    });

    it("dont detect collision on a same command level", function () {
      shell({
        // options: collide: {}
        commands: {
          server: {
            commands: {
              start: {
                options: { collide: {} },
              },
              stop: {
                options: { collide: {} },
              },
            },
          },
        },
      });
    });

    it("detect collision between application and command options", function () {
      (function () {
        shell({
          options: {
            collide: {},
          },
          commands: {
            start: {
              options: { collide: {} },
            },
          },
        });
      }).should.throw(
        'Invalid Option Configuration: option "collide" in command "start" collide with the one in application, change its name or use the extended property',
      );
    });

    it("detect collision between 2 command options", function () {
      shell({
        extended: true,
        commands: {
          server: {
            options: {
              collide: {},
            },
            commands: {
              start: {
                options: { v: {} },
              },
            },
          },
        },
      });
      // Not OK in flatten mode
      (function () {
        shell({
          commands: {
            server: {
              options: {
                collide: {},
              },
              commands: {
                start: {
                  options: { collide: {} },
                },
              },
            },
          },
        });
      }).should.throw(
        'Invalid Option Configuration: option "collide" in command "server start" collide with the one in "server", change its name or use the extended property',
      );
    });
  });
});
