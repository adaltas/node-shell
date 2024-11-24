import fs from "node:fs/promises";
import os from "node:os";
import { shell } from "../../lib/index.js";

describe("router.handler", function () {
  it("context is parameter instance", function () {
    shell({
      handler: function () {
        this.should.have.property("help").which.is.a.Function();
        this.should.have.property("parse").which.is.a.Function();
        this.should.have.property("compile").which.is.a.Function();
      },
    }).route([]);
  });

  it("load with custom function handler", async function () {
    await fs.writeFile(
      `${os.tmpdir()}/renamed_module.coffee`,
      'export default -> "Hello"',
    );
    await shell({
      handler: "./something",
      load: async function (module, namespace) {
        if (module !== "./something") throw Error("Incorrect module name");
        const location = `${os.tmpdir()}/renamed_module.coffee`;
        return (await import(location))[namespace];
      },
    })
      .route([])
      .should.be.resolvedWith("Hello");
    await fs.unlink(`${os.tmpdir()}/renamed_module.coffee`);
  });

  describe("arguments", function () {
    it("pass a single info argument by default", function () {
      shell({
        options: {
          my_argument: {},
        },
        handler: function (context) {
          Object.keys(context)
            .sort()
            .should.eql([
              "args",
              "argv",
              "command",
              "error",
              "params",
              "stderr",
              "stderr_end",
              "stdin",
              "stdout",
              "stdout_end",
            ]);
          arguments.length.should.eql(1);
        },
      }).route(["--my_argument", "my value"]);
    });

    it("pass user arguments", function (next) {
      shell({
        options: {
          my_argument: {},
        },
        handler: function (context, my_param, callback) {
          my_param.should.eql("my value");
          callback.should.be.a.Function();
          callback(null, "something");
        },
      }).route(
        ["--my_argument", "my value"],
        "my value",
        function (err, value) {
          value.should.eql("something");
          next();
        },
      );
    });
  });

  describe("returned value", function () {
    it("inside an application", function () {
      shell({
        handler: function ({ params }) {
          return params.my_argument;
        },
        options: {
          my_argument: {},
        },
      })
        .route(["--my_argument", "my value"])
        .should.eql("my value");
    });

    it("inside a command", function () {
      shell({
        commands: {
          my_command: {
            handler: function ({ params }) {
              return params.my_argument;
            },
            options: {
              my_argument: {},
            },
          },
        },
      })
        .route(["my_command", "--my_argument", "my value"])
        .should.eql("my value");
    });
  });
});
