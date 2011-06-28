ImageFilers =
  filesystem: require('image_on_filesystem').ImageOnFilesystem
  http: require('image_over_http').ImageOverHttp

exports.instance = (config, httpResponse) ->
  new ImageFilers[config.imageSource.type.toLowerCase()](config, httpResponse)
