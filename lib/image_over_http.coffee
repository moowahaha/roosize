gd = require 'node-gd'
http = require 'http'
url = require 'url'
e = require 'exception_reporter'

exports.ImageOverHttp = (configuration, httpResponse) ->
  this.response = httpResponse
  this.name = 'http'

  this.open = (filename, callback) ->
    imageFile = this

    imageSource = url.parse(configuration.imageSource.path + '/' + filename.replace(/^\//, ''))

    client = http.createClient 80, imageSource.host
    image = null

    request = client.request(
      'GET', imageSource.pathname, {host: imageSource.host}
    )

    request.end()

    request.on 'response', (response) ->
      if response.statusCode is 404
        e.reportUserError(404, 'No such file on remote host ' + filename, httpResponse)
        return

      imageFile.mimeType = response.headers['content-type']
      imageFile.modified = new Date(response.headers['last-modified'])
      imageFile.type = imageFile.mimeType.split('/')[1]

      response.setEncoding('binary')
      data = ''

      response.on 'data', (chunk) ->
        data += chunk

      response.on 'end', ->
        imageFile.data = gd['createFrom' + imageFile.type.charAt(0).toUpperCase() + imageFile.type.slice(1) + 'Ptr'](data)

        newImage = callback imageFile

        imageFile.response.writeHead(200, {'Content-Type': imageFile.mimeType})
        imageFile.response.end(newImage[imageFile.type + 'Ptr'](), 'binary')

  return