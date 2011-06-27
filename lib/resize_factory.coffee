ResizeStrategies =
  pad: require('resize/pad').ResizePad
  crop: require('resize/crop').ResizeCrop
  stretch: require('resize/stretch').ResizeStretch
  scale: require('resize/scale').ResizeScale

exports.ResizeFactory = (configuration, request, httpResponse) ->
  params =
    paddingcolor: configuration.requestDefault('paddingColor').value
    strategy: configuration.requestDefault('strategy').value

  Object.keys(request.params).forEach (key) ->
    return if (!params[key.toLowerCase()])

    if (!configuration.requestDefault(key).allowOverride)
      error = 'You cannot specify a ' + key.toLowerCase()
      httpResponse.writeHead(403, {})
      httpResponse.end(error)

      throw {
        name: 'EPERM'
        message: error
      }

    params[key.toLowerCase()] = request.params[key].toLowerCase()

  if !ResizeStrategies[params.strategy]
    error = 'Unknown strategy ' + params.strategy
    httpResponse.writeHead(406, {})
    httpResponse.end(error)

    throw {
      name: 'EPERM'
      message: error
    }

  this.instance = new ResizeStrategies[params.strategy](params)

  return
