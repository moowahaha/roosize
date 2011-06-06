// taken from http://elegantcode.com/2011/03/07/taking-baby-steps-with-node-js-bdd-style-unit-tests-with-jasmine-node-sprinkled-with-some-should/
require.paths.unshift('./lib');

var jasmine = require('jasmine-node');
var sys = require('sys');

for(var key in jasmine) {
  global[key] = jasmine[key];
}

var isVerbose = true;
var showColors = true;

process.argv.forEach(function(arg){
    switch(arg) {
          case '--color': showColors = true; break;
          case '--noColor': showColors = false; break;
          case '--verbose': isVerbose = true; break;
      }
});

jasmine.executeSpecsInFolder(__dirname + '/spec', function(runner, log){
  if (runner.results().failedCount == 0) {
    process.exit(0);
  }
  else {
    process.exit(1);
  }
}, isVerbose, showColors);
