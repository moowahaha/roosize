gd = require 'node-gd'

exports.ResizeCrop = ->

  offset = (calculatedLength, requestedLength) ->
    Math.round(
      (
        if calculatedLength > requestedLength
          requestedLength - calculatedLength
        else
          calculatedLength - requestedLength
      ) / 2
    )

  name: 'crop'

  resize: (request, originalImage) ->
    newImage = gd.createTrueColor(request.width, request.height)

    originalRatio = originalImage.width / originalImage.height
    newRatio = request.width / request.height

    newWidth = request.width
    newHeight = request.height

    if newRatio > originalRatio
      newHeight = Math.floor(request.width / originalRatio)
    else
      newWidth = Math.floor(request.height * originalRatio)

    originalImage.copyResampled(
      newImage,
      offset(newWidth, request.width),
      offset(newHeight, request.height),
      0,
      0,
      newWidth,
      newHeight,
      originalImage.width,
      originalImage.height
    )

    return newImage
