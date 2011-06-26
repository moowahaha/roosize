url = require 'url'

exports.Request = (requestString, config) ->
  parsedUrl = url.parse(requestString.replace(/^\//, ''))

  pathParts = parsedUrl.pathname.split('/')
  dimensions = pathParts.shift().split('x')

  this.width = parseInt dimensions[0]
  this.height = parseInt dimensions[1]
  this.path = pathParts.join('/')
  return