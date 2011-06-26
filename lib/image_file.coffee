fs = require('fs')
path = require('path')
mime = require('mime')
gd = require('node-gd')

exports.ImageFile = (configuration) ->
  this.open = (filename) ->
    fullPath = path.join(configuration.imageSource.path, filename)

    stat = fs.statSync(fullPath)
    this.modified = stat.mtime

    this.mimeType = mime.lookup(fullPath)
    this.type = this.mimeType.split('/')[1]

    this.data = gd['createFrom' + this.type.charAt(0).toUpperCase() + this.type.slice(1) + 'Ptr'](fs.readFileSync(fullPath, "binary"))

  return