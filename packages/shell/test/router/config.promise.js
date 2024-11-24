import { shell } from "../../lib/index.js";

describe("router.config.promise", function () {
  it("handler throw error", function () {
    return shell({
      options: {
        my_argument: {},
      },
      router: {
        promise: true,
      },
      handler: function () {
        throw Error("catch me");
      },
    })
      .route(["--my_argument", "my value"])
      .should.be.rejectedWith("catch me");
  });

  it("old handler return value", async function () {
    await shell({
      options: {
        my_argument: {},
      },
      router: {
        promise: true,
      },
      handler: function (context) {
        return context.params.my_argument;
      },
    })
      .route(["--my_argument", "my value"])
      .should.be.resolvedWith("my value");
  });

  it("handler return undefined", function () {
    return shell({
      options: {
        my_argument: {},
      },
      router: {
        promise: true,
      },
      handler: function () {},
    })
      .route(["--my_argument", "my value"])
      .should.be.resolvedWith(undefined);
  });
});
