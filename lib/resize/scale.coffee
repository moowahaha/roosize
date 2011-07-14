gd = require 'node-gd'

exports.ResizeScale = ->

  name: 'scale'

  resize: (request, originalImage) ->
    originalRatio = originalImage.width / originalImage.height
    newRatio = request.width / request.height

    newWidth = request.width
    newHeight = request.height

    if newRatio > originalRatio
      newWidth = Math.floor(request.height * originalRatio)
    else
      newHeight = Math.floor(request.width / originalRatio)

    newImage = gd.createTrueColor(newWidth, newHeight)

    originalImage.copyResampled(
      newImage,
      0,
      0,
      0,
      0,
      newWidth,
      newHeight,
      originalImage.width,
      originalImage.height
    )

    return newImage
