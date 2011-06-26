#var spawn = require('child_process').spawn,
#        http = require('http'),
#        remote_client = http.createClient(8080, 'localhost'),
#        roosize, request;
#
#
#describe('roosize', function () {
#    beforeEach(function () {
#        roosize = spawn('node', ['roosize.js', 'spec/fixtures/full_config.json']);
#        request = remote_client.request('GET', '/images/bob.jpg');
#
#        var data = '';
#        request.end();
#        request.on('response', function(response) {
#            console.log('aaaaaaaaaaaa');
#            response.addListener('data', function(chunk) {
#                data += chunk;
#            });
#        });
#        console.log(data);
#    });
#
#    afterEach(function () {
#        roosize.kill('SIGHUP');
#    });
#
#    it('should blah', function () {
#        expect(true).toEqual(false);
#    });
#});
#
#
#var http = require('http');
#var google = http.createClient(80, 'www.google.com');
#var request = google.request('GET', '/',
#  {'host': 'www.google.com'});
#request.end();
#request.on('response', function (response) {
#  console.log('STATUS: ' + response.statusCode);
#  console.log('HEADERS: ' + JSON.stringify(response.headers));
#  response.setEncoding('utf8');
#  response.on('data', function (chunk) {
#    console.log('BODY: ' + chunk);
#  });
#});