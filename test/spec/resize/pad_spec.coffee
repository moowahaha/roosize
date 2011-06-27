ResizePad = require('resize/pad').ResizePad
ImageFile = require('image_file').ImageFile
Configuration = require('configuration').Configuration
Request = require('request').Request
ColorConverter = require('color_converter').ColorConverter

describe 'ResizePad', ->
  _resizer = null
  _newImage = null
  _converter = new ColorConverter

  beforeEach ->
    _resizer = new ResizePad(
      paddingcolor: 'FFFFFF'
    )
    config = new Configuration('./test/fixtures/minimal_config_with_override.json')
    request = new Request('/100x200/images/black_square.jpg', config)
    imageFile = new ImageFile(config)

    _newImage = _resizer.resize(request, imageFile.open(request.path))

  it 'should have a name', ->
    expect(_resizer.name).toEqual('pad')

  it 'should resize to given width', ->
    expect(_newImage.width).toEqual(100)

  it 'should resize to given height', ->
    expect(_newImage.height).toEqual(200)

  it 'should pad the top of the image white', ->
    p = _newImage.getPixel(1,1)
    expect(_converter.fromDecimal([_newImage.red(p), _newImage.green(p), _newImage.blue(p)])).toEqual('ffffff')

  it 'should pad the bottom of the image white', ->
    p = _newImage.getPixel(1,199)
    expect(_converter.fromDecimal([_newImage.red(p), _newImage.green(p), _newImage.blue(p)])).toEqual('ffffff')

  it 'should keep the middle of the image black', ->
    p = _newImage.getPixel(50,100)
    expect(_converter.fromDecimal([_newImage.red(p), _newImage.green(p), _newImage.blue(p)])).toEqual('000000')