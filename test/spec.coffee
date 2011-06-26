require.paths.unshift('./lib')
require 'coffee-script'

jasmine = require 'jasmine-node'

for key in jasmine
  do (key) ->
    global[key] = jasmine[key]

jasmine.executeSpecsInFolder __dirname + '/spec', (runner, log) ->

  if runner.results().failedCount is 0
    process.exit(0)
  else
    process.exit(1)
, true, true, '_spec.coffee$'
