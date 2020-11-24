
const shell = require('./packages/shell');
const { spawn } = require('child_process')

shell({
  commands: {
    'list': {
      main: 'input',
      route: async function({params, stderr, stdout}){
        const ls = spawn('ls', ['-lh', ...params.input])
        ls.stderr.pipe(stderr)
        ls.stdout.pipe(stdout)
      }
    }
  }
}).route()
