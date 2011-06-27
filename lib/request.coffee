url = require 'url'

exports.Request = (requestString, config, httpResponse) ->
  parsedUrl = url.parse(requestString.replace(/^\//, ''), true)
  this.params = parsedUrl.query

  if parsedUrl.pathname
    pathParts = parsedUrl.pathname.split('/')
    dimensions = pathParts.shift().split('x')

    this.width = parseInt dimensions[0]
    this.height = parseInt dimensions[1]
    this.path = pathParts.join('/')

  if (!this.width || !this.height || !this.path)
    error = 'Invalid resource: ' + requestString
    httpResponse.writeHead(406, {})
    httpResponse.end(error)
    throw error

  return