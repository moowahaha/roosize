var fs = require('fs'),
        path = require('path'),
        mime = require('mime');

exports.ImageFile = function (configuration) {
    this.open = function (filename) {
        var fullPath = path.join(configuration.imageSource.path, filename);

        var stat = fs.statSync(fullPath);
        this.modified = stat['mtime'];

        this.mimeType = mime.lookup(fullPath);
        this.type = this.mimeType.split('/')[1];
    }
}
