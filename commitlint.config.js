const {utils: {getPackages}} = require('@commitlint/config-lerna-scopes');

module.exports = {
 rules: {
  'scope-enum': async ctx => 
    [2, 'always', [...(await getPackages(ctx)), 'release']]
 }
}
