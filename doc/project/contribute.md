
# Contribution

## Development

Tests are executed with mocha. To install it, simple run `npm install`, it will
install mocha and its dependencies in your project "node_modules" directory.

To run the tests:
```bash
npm test
```

The tests run against the CoffeeScript source files.

To generate the JavaScript files:
```bash
make build
```

The test suite is run online with [Travis][travis] against the supported 
Node.js versions.

## Contributors

*   David Worms: <https://github.com/wdavidw>

This package is developed by [Adaltas](http://www.adaltas.com).

[ws]: https://nodejs.org/api/stream.html#stream_writable_streams
