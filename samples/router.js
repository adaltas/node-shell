const parameters = require('..')
const { spawn } = require('child_process')
const util = require('util');

parameters({
  commands: {
    'list': {
      main: {
        name: 'input',
        required: true
      },
      options: {
        port: {
          type: 'integer'
        }
      },
      route: async function({params, stderr, stdout}){
        const ls = spawn('ls', ['-lh', ...params.input])
        ls.stderr.pipe(stderr)
        ls.stdout.pipe(stdout)
      }
    }
  }
}).route()
