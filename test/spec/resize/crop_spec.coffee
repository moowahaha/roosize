ResizeCrop = require('resize/crop').ResizeCrop
ImageOnFilesystem = require('image_on_filesystem').ImageOnFilesystem
Configuration = require('configuration').Configuration
Request = require('request').Request
FakeHttpResponse = require('fake_http_response').FakeHttpResponse
colorConverter = require 'color_converter'

describe 'ResizeCrop', ->
  _resizer = null
  _newImage = null

  beforeEach ->
    _newImage = null
    _resizer = new ResizeCrop()
    config = new Configuration('./test/fixtures/minimal_config_with_override.json')
    request = new Request('/100x200/images/black_square.jpg', config)
    imageFile = new ImageOnFilesystem(config, new FakeHttpResponse)

    imageFile.open(request.path, ->
      _newImage = _resizer.resize(request, imageFile.data)
    )

    waitsFor ->
       _newImage?

  it 'should have a name', ->
    expect(_resizer.name).toEqual('crop')

  it 'should resize to given width', ->
    expect(_newImage.width).toEqual(100)

  it 'should resize to given height', ->
    expect(_newImage.height).toEqual(200)
