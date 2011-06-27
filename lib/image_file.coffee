fs = require 'fs'
path = require 'path'
mime = require 'mime'
gd = require 'node-gd'

exports.ImageFile = (configuration, httpResponse) ->
  this.open = (filename) ->
    fullPath = path.join(configuration.imageSource.path, filename)

    try
      stat = fs.statSync(fullPath)
      this.modified = stat.mtime
    catch err
      if err.code is 'ENOENT'
        httpResponse.writeHead(404, {})
        httpResponse.end('No such file on disk ' + filename)

      throw err

    this.mimeType = mime.lookup(fullPath)
    this.type = this.mimeType.split('/')[1]

    this.data = gd['createFrom' + this.type.charAt(0).toUpperCase() + this.type.slice(1) + 'Ptr'](fs.readFileSync(fullPath, "binary"))

  return