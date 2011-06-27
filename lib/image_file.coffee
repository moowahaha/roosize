fs = require 'fs'
path = require 'path'
mime = require 'mime'
gd = require 'node-gd'

exports.ImageFile = (configuration, httpResponse) ->
  this.response = httpResponse

  this.open = (filename, callback) ->
    fullPath = path.join(configuration.imageSource.path, filename)

    try
      stat = fs.statSync(fullPath)
      this.modified = stat.mtime
    catch err
      if err.code is 'ENOENT'
        httpResponse.writeHead(404, {})
        httpResponse.end('No such file on disk ' + filename)

      throw err

    imageFile = this

    fs.readFile(fullPath, "binary", (err, data) ->
      throw err if err
      imageFile.mimeType = mime.lookup(fullPath)
      imageFile.type = imageFile.mimeType.split('/')[1]
      imageFile.data = gd['createFrom' + imageFile.type.charAt(0).toUpperCase() + imageFile.type.slice(1) + 'Ptr'](data)

      newImage = callback imageFile

      imageFile.response.writeHead(200, {'Content-Type': imageFile.mimeType})
      imageFile.response.end(newImage[imageFile.type + 'Ptr'](), 'binary')
    )

  return