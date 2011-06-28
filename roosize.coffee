require.paths.unshift([__dirname, 'lib'].join('/'))

http = require 'http'

Configuration = require('configuration').Configuration
imageFileFactory = require('image_file_factory')
resizeFactory = require('resize_factory')
Request = require('request').Request
e = require 'exception_reporter'

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
    return unless request.valid

    resizer = resizeFactory.resolve(config, request, httpResponse)
    imageFile = imageFileFactory.resolve(config, httpResponse)

    imageFile.open(request.path, ->
      resizer.resize(request, imageFile.data)
    )
  catch err
    e.reportUnknownException(err, httpResponse)

).listen(config.listenPort)

console.log('Listening on port ' + config.listenPort)