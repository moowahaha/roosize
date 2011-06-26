# taken from http://elegantcode.com/2011/03/07/taking-baby-steps-with-node-js-bdd-style-unit-tests-with-jasmine-node-sprinkled-with-some-should/
require.paths.unshift('./lib')

require 'coffee-script'

jasmine = require 'jasmine-node'
sys = require 'sys'
spawn = require('child_process').spawn
roosize = spawn('node', ['roosize']);

roosize.stdout.on 'data', (data) ->
  console.warn(data.toString())

  if data.toString().match(/Listening/)
    for key in jasmine
      do (key) ->
        global[key] = jasmine[key]

    jasmine.executeSpecsInFolder __dirname + '/spec', (runner, log) ->
      roosize.kill('SIGTERM')

      if runner.results().failedCount is 0
        process.exit(0)
      else
        process.exit(1)
    , true, true, '_spec.coffee$'
