gd = require 'node-gd'

exports.ResizeStretch = (params) ->

  name: 'stretch'

  resize: (request, originalImage) ->
    newImage = gd.createTrueColor(request.width, request.height)

    originalImage.copyResampled(
      newImage,
      0,
      0,
      0,
      0,
      request.width,
      request.height,
      originalImage.width,
      originalImage.height
    )

    return newImage
