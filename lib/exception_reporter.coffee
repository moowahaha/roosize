exports.reportUnknownException = (err, httpResponse) ->
  console.warn(if err.message then err.message else 'Unknown excpetion')
  httpResponse.writeHead 500, {'Content-Type': 'text/plain'}
  httpResponse.end 'Internal server error'

exports.reportUserError = (code, message, httpResponse) ->
  console.log message
  httpResponse.writeHead code, {'Content-Type': 'text/plain'}
  httpResponse.end message
