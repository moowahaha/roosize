fs = require 'fs'
path = require 'path'
mime = require 'mime'
gd = require 'node-gd'
e = require 'exception_reporter'

exports.ImageOnFilesystem = (configuration, httpResponse) ->
  this.response = httpResponse
  this.name = 'filesystem'

  this.open = (filename, callback) ->
    fullPath = path.join(configuration.imageSource.path, filename)

    imageFile = this

    fs.readFile(fullPath, "binary", (err, data) ->
      if err
        if err.code is 'ENOENT'
          e.reportUserError(404, 'No such file on disk ' + filename, imageFile.response)
        else
          e.reportUnknownExcpetion(500, err, imageFile.response)

        return

      stat = fs.statSync(fullPath)
      imageFile.modified = stat.mtime
      imageFile.mimeType = mime.lookup(fullPath)
      imageFile.type = imageFile.mimeType.split('/')[1]
      imageFile.data = gd['createFrom' + imageFile.type.charAt(0).toUpperCase() + imageFile.type.slice(1) + 'Ptr'](data)

      newImage = callback imageFile

      imageFile.response.writeHead(200, {'Content-Type': imageFile.mimeType})
      imageFile.response.end(newImage[imageFile.type + 'Ptr'](), 'binary')
    )

  return