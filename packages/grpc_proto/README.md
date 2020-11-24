
# Package `@shell-js/grpc_proto`

Store the Protocol Buffer definition file used by the GRPC server and client packages.

Additionnal, the package provide some functions to facilitate its usage:

* `resolve`   
  Return the `shell.proto` location.
* `load`   
  Load .proto files for use with gRPC.
* `loadSync`   
  Synchronous version of `load`.

## Note

The Protocol Buffer definition is stored in a file. We could probably make it dynamic with [grpc-tools](https://www.npmjs.com/package/grpc-tools).
