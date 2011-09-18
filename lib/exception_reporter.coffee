exports.reportUnknownException = (err, httpResponse) ->
  GLOBAL.logger.error(if err.message then err.message else 'Unknown excpetion')
  httpResponse.writeHead 500, {'Content-Type': 'text/plain'}
  httpResponse.end 'Internal server error'

exports.reportUserError = (code, message, httpResponse) ->
  GLOBAL.logger.log message
  httpResponse.writeHead code, {'Content-Type': 'text/plain'}
  httpResponse.end message
