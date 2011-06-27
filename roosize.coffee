require.paths.unshift([__dirname, 'lib'].join('/'))

http = require 'http'

Configuration = require('configuration').Configuration
ImageFile = require('image_file').ImageFile
ResizeFactory = require('resize_factory').ResizeFactory
Request = require('request').Request

#TODO: make this more robust
configFile = process.argv[2]
unless configFile?
  console.warn('Missing parameter: config file')
  process.exit(-1)

config = new Configuration(configFile)

http.Agent.defaultMaxSockets = config.connectionLimit

http.createServer((httpRequest, httpResponse) ->

  try
    request = new Request(httpRequest.url, config, httpResponse)

    imageFile = new ImageFile(config, httpResponse)
    imageFile.open(request.path)

    resizeFactory = new ResizeFactory(config, request, httpResponse)
    newImage = resizeFactory.instance.resize(request, imageFile.data)

    httpResponse.writeHead(200, {'Content-Type': imageFile.mimeType});
    httpResponse.end(newImage.jpegPtr(), 'binary');

  catch err
    console.log(if err.message then err.message else 'Unknown error when requesting ' + httpRequest.url)
    httpResponse.writeHead(500, {})
    httpResponse.end('Internal server error')

).listen(config.listenPort)

console.log('Listening on port ' + config.listenPort)