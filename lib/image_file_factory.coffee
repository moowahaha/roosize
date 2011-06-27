ImageFilers =
  filesystem: require('image_on_filesystem').ImageOnFilesystem
  http: require('image_over_http').ImageOverHttp

exports.resolve = (config, httpResponse) ->
  this.instance = new ImageFilers[config.imageSource.type.toLowerCase()](config, httpResponse)
