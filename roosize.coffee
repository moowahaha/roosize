require.paths.unshift([__dirname, 'lib'].join('/'))

http = require 'http'

Configuration = require('configuration').Configuration
imageFileFactory = require('image_file_factory')
resizeFactory = require('resize_factory')
Request = require('request').Request
e = require 'exception_reporter'
commander = require 'commander'

commander
  .version('0.0.1')
  .option('-c, --config [file]', 'Configuration file')
  .option('-s, --syslog', 'Use syslog', false)
  .parse(process.argv)

GLOBAL.logger = console

if commander.syslog
  GLOBAL.logger = require('ain').set('roosize', 'daemon.roosize')

if !commander.config
  GLOBAL.logger.error 'Configuration file must be supplied.'
  process.exit -1

config = new Configuration(commander.config)

http.Agent.defaultMaxSockets = config.connectionLimit

http.createServer((httpRequest, httpResponse) ->

  try
    request = new Request(httpRequest.url, config, httpResponse)
    return unless request.valid

    resizer = resizeFactory.instance(config, request, httpResponse)
    imageFile = imageFileFactory.instance(config, httpResponse)

    imageFile.open(request.path, ->
      if imageFile.data.width == request.width && imageFile.data.height == request.height
        return imageFile.data
        
      resizer.resize(request, imageFile.data)
    )
  catch err
    e.reportUnknownException(err, httpResponse)

).listen(config.listenPort)

GLOBAL.logger.log('Listening on port ' + config.listenPort)