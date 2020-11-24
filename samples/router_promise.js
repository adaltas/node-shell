
const shell = require('./packages/shell');
const { spawn } = require('child_process')

(async function(){
  try{
    const result = await shell({
      commands: {
        'list': {
          main: 'input',
          route: async function({params, error, stderr, stdout}){
            return new Promise(function(resolve, reject){
              const ls = spawn('ls', ['-lh', ...params.input])
              ls.stderr.pipe(stderr)
              ls.stdout.pipe(stdout)
              ls.on('close', (code) => {
                code === 0
                ? resolve('Command succeed!')
                : reject(new Error(`Command failed with code: ${code}`))
              });
            })
          }
        }
      }
    }).route()
    console.log(`=== ${result} ===`)
  }catch(err){
    console.error(`=== ${err.message} ===`)
  }
})()
