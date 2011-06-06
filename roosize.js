var sys = require('sys'),
        http = require('http'),
        url = require('url'),
        path = require('path'),
        fs = require('fs'),
        gd = require('node-gd'),
        daemon = require('daemon'),
        mime = require('mime');

http.Agent.defaultMaxSockets = 20;

var config = readConfig();

config['paddingColor'] = config['paddingColor'].toUpperCase();

var supportedImageTypes = [
    'Jpeg', 'Png', 'Gif'
];

try {
    daemon.chroot(config['rootDirectory']);
} catch (err) {
    if (err['code'] != 'EPERM')
        throw err

    console.error('Cannot chroot to ' + config['rootDirectory'] + ': ' + err);
    console.error('Will rely on request level security...');
    process.chdir(config['rootDirectory']);
}

function readConfig() {
    var filename = path.join(process.cwd(), 'config.json');
    var configString = fs.readFileSync(filename, 'utf-8');
    return JSON.parse(configString);
}

function hexToR(h) {
    return parseInt(h.substring(0, 2), 16)
}
function hexToG(h) {
    return parseInt(h.substring(2, 4), 16)
}
function hexToB(h) {
    return parseInt(h.substring(4, 6), 16)
}

function parseFileRequest(url) {
    var parts = url.split('/');
    var fileRequest = {};

    parts.shift();
    var dimensions = parts.shift().split('x');
    fileRequest['width'] = parseInt(dimensions[0]);
    fileRequest['height'] = parseInt(dimensions[1]);

    var nicePath = [];

    parts.forEach(function (part) {
        switch (part) {
            case '':
                next;
            case '..':
                next;
            default:
                nicePath.push(part);
        }
    });

    fileRequest['file'] = nicePath.join('/');

    return fileRequest;
}

function offset(calculatedLength, requestedLength) {
    return (
            Math.round((
                    calculatedLength > requestedLength ?
                            calculatedLength - requestedLength :
                            requestedLength - calculatedLength
                    ) / 2)
            );
}

function processRequest(fileRequest, filename, response, config) {
    mimeType = mime.lookup(filename);
    var imageFormat = mimeType.split('/')[1];
    imageFormat = imageFormat.charAt(0).toUpperCase() + imageFormat.slice(1);

    if (supportedImageTypes.indexOf(imageFormat) < 0) {
        response.writeHead(406, {'Content-Type': 'text/plain'});
        response.end("Not supported", 'binary');
        return;
    }

    gd['open' + imageFormat](filename, function(image, path) {
        var newImage = gd.createTrueColor(fileRequest['width'], fileRequest['height']);
        newImage.fill(
                0,
                0,
                newImage.colorAllocate(
                        hexToR(config['paddingColor']),
                        hexToG(config['paddingColor']),
                        hexToB(config['paddingColor'])
                        )
                );

        var originalRatio = image.width / image.height;
        var newRatio = fileRequest['width'] / fileRequest['height'];

        var newWidth = fileRequest['width'];
        var newHeight = fileRequest['height'];

        if (newRatio > originalRatio) {
            newWidth = Math.floor(fileRequest['height'] * originalRatio);
        }
        else {
            newHeight = Math.floor(fileRequest['width'] / originalRatio);
        }

        image.copyResampled(
                newImage,
                offset(newWidth, fileRequest['width']),
                offset(newHeight, fileRequest['height']),
                0,
                0,
                newWidth,
                newHeight,
                image.width,
                image.height
                );

        response.writeHead(200, {'Content-Type': mimeType});
        response.end(newImage[imageFormat.toLowerCase() + 'Ptr'](), 'binary');
    });

}

http.createServer(
        function(request, response) {
            var fileRequest = parseFileRequest(url.parse(request.url).pathname);
            var filename = fileRequest['file'];

            console.log('File requested: ' + [config['rootDirectory'], filename].join('/'));

            path.exists(filename, function(exists) {
                if (!exists) {
                    response.writeHead(404, {'Content-Type': 'text/plain'});
                    response.end('404 Not Found\n');
                    return;
                }

                processRequest(fileRequest, filename, response, config);
            });
        }
        ).listen(parseInt(config['listenPort']));

console.log('Listening on port ' + config['listenPort']);

