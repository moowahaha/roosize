require.paths.unshift('./lib')
require.paths.unshift('./test/helpers')

require 'coffee-script'

jasmine = require 'jasmine-node'

GLOBAL.logger = console

for key in jasmine
  do (key) ->
    global[key] = jasmine[key]

jasmine.executeSpecsInFolder __dirname + '/spec', (runner, log) ->

  if runner.results().failedCount is 0
    process.exit(0)
  else
    process.exit(1)
, true, true, process.argv[2] || '_spec.coffee$'
