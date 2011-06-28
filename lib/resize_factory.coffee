e = require 'exception_reporter'

ResizeStrategies =
  pad: require('resize/pad').ResizePad
  crop: require('resize/crop').ResizeCrop
  stretch: require('resize/stretch').ResizeStretch
  scale: require('resize/scale').ResizeScale

exports.instance = (configuration, request, httpResponse) ->
  params =
    paddingcolor: configuration.requestDefault('paddingColor').value
    strategy: configuration.requestDefault('strategy').value

  Object.keys(request.params).forEach (key) ->
    return if (!params[key.toLowerCase()])

    if (!configuration.requestDefault(key).allowOverride)
      e.reportUserError(403, 'You cannot specify a ' + key.toLowerCase(), httpResponse)
      return

    params[key.toLowerCase()] = request.params[key].toLowerCase()

  if !ResizeStrategies[params.strategy]
    e.reportUserError(406, 'Unknown strategy ' + params.strategy, httpResponse)
    return

  new ResizeStrategies[params.strategy](params)
