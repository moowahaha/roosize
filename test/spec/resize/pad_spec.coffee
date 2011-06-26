ResizePad = require('resize/pad').ResizePad
ImageFile = require('image_file').ImageFile
Configuration = require('config').Configuration
Request = require('request').Request

describe 'ResizePad', ->
  _resizer = null
  _newImage = null

  beforeEach ->
    _resizer = new ResizePad
    config = new Configuration('./test/fixtures/minimal_config.json')
    request = new Request('/100x200/images/black_square.jpg', config)
    imageFile = new ImageFile(config)

    _newImage = _resizer.resize(
      imageData: imageFile.open(request.path)
      request: request
    )

  it 'should have a name', ->
    expect(_resizer.name).toEqual('pad')

  it 'should resize to given width', ->
    expect(_newImage.width).toEqual(100)

  it 'should resize to given height', ->
    expect(_newImage.height).toEqual(200)
