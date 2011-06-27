url = require 'url'
e = require 'exception_reporter'

exports.Request = (requestString, config, httpResponse) ->
  parsedUrl = url.parse(requestString.replace(/^\//, ''), true)
  this.params = parsedUrl.query
  this.valid = true

  if parsedUrl.pathname
    pathParts = parsedUrl.pathname.split('/')
    dimensions = pathParts.shift().split('x')

    this.width = parseInt dimensions[0]
    this.height = parseInt dimensions[1]
    this.path = pathParts.join('/')

  if (!this.width || !this.height || !this.path)
    e.reportUserError(406, 'Invalid resource: ' + requestString, httpResponse)
    this.valid = false

  return