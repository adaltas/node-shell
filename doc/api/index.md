
# Usage

The parameters package is made available to your module with the declaration
`const parameters = require('parameters');`. The returned variable is a function
expecting a configuration object and returning the following functions:

* `help` (command[string|null])   
  Returned a string with the complete help content or the content of a single 
  command if the command argument is passed.
* `parse` (argv[array|process])   
  Transform an array of arguments into a parameter object. If null
  or the native `process` object, the first two arguments (the node
  binary and the script file) are skipped.
* `load` (module[string])   
  Internal function used to load modules, see the "load" option to pass a
  function or a module referencing the function.
* `route` (argv[array|process], args[mixed]...)   
  Similar to parse but it will also call the function defined by the "route"
  option. The first argument is the arguments array to parse, other arguments
  are simply transmitted to the `route` method or module as additional arguments.
  The `route` method provided by the user receives the parsed parameters as its
  first argument. If the option "extended" is activated, it also receives the
  original arguments and configuration as second and third   arguments. Any user
  provided arguments are transmitted as is as additional arguments.
* `stringify` (params[obj], options[obj])   
  Convert an object of parameters into an array of arguments. Possible options
  are "no_default".
