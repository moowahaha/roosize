gd = require 'node-gd'

exports.ResizePad = ->
  name: 'pad'
  resize: (params) ->
    request = params.request
    originalImage = params.imageData

    newImage = gd.createTrueColor(request.width, request.height);

    return newImage