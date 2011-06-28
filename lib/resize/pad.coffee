gd = require 'node-gd'
colorConverter = require('color_converter')

exports.ResizePad = (params) ->

  offset = (calculatedLength, requestedLength) ->
    Math.round(
      (
        if calculatedLength > requestedLength
          calculatedLength - requestedLength
        else
          requestedLength - calculatedLength
      ) / 2
    )

  instantiateImage: (request) ->
    newImage = gd.createTrueColor(request.width, request.height)

    colorArray = colorConverter.fromHex(this.paddingColor)

    newImage.fill(
      0,
      0,
      newImage.colorAllocate(
        colorArray[0],
        colorArray[1],
        colorArray[2]
      )
    )

  paddingColor: params.paddingcolor.toUpperCase()
  name: 'pad'

  resize: (request, originalImage) ->
    newImage = this.instantiateImage request

    originalRatio = originalImage.width / originalImage.height
    newRatio = request.width / request.height

    newWidth = request.width
    newHeight = request.height

    if newRatio > originalRatio
      newWidth = Math.floor(request.height * originalRatio)
    else
      newHeight = Math.floor(request.width / originalRatio)

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
