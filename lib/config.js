var fs = require('fs');

exports.Configuration = function (filename) {
    var configString = fs.readFileSync(filename, 'utf-8');
    var hash = JSON.parse(configString);

    this.root = hash['root'];
}