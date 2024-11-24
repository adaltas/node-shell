import "should";
import { shell } from "shell";

shell({
  main: "input",
})
  .parse([])
  .should.eql({
    input: [],
  });
