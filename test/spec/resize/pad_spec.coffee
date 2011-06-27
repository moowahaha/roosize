ResizePad = require('resize/pad').ResizePad
ImageOnFilesystem = require('image_on_filesystem').ImageOnFilesystem
Configuration = require('configuration').Configuration
Request = require('request').Request
FakeHttpResponse = require('fake_http_response').FakeHttpResponse
colorConverter = require 'color_converter'

describe 'ResizePad', ->
  _resizer = null
  _newImage = null

  beforeEach ->
    _newImage = null
    _resizer = new ResizePad(
      paddingcolor: 'FFFFFF'
    )
    config = new Configuration('./test/fixtures/minimal_config_with_override.json')
    request = new Request('/100x200/images/black_square.jpg', config)
    imageFile = new ImageOnFilesystem(config, new FakeHttpResponse)

    imageFile.open(request.path, ->
      _newImage = _resizer.resize(request, imageFile.data)
    )

    waitsFor ->
       _newImage?

  it 'should have a name', ->
    expect(_resizer.name).toEqual('pad')

  it 'should resize to given width', ->
    expect(_newImage.width).toEqual(100)

  it 'should resize to given height', ->
    expect(_newImage.height).toEqual(200)

  it 'should pad the top of the image white', ->
    p = _newImage.getPixel(1,1)
    expect(colorConverter.fromDecimal([_newImage.red(p), _newImage.green(p), _newImage.blue(p)])).toEqual('ffffff')

  it 'should pad the bottom of the image white', ->
    p = _newImage.getPixel(1,199)
    expect(colorConverter.fromDecimal([_newImage.red(p), _newImage.green(p), _newImage.blue(p)])).toEqual('ffffff')

  it 'should keep the middle of the image black', ->
    p = _newImage.getPixel(50,100)
    expect(colorConverter.fromDecimal([_newImage.red(p), _newImage.green(p), _newImage.blue(p)])).toEqual('000000')