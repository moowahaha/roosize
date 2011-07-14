ResizeScale = require('resize/scale').ResizeScale
ImageOnFilesystem = require('image_on_filesystem').ImageOnFilesystem
Configuration = require('configuration').Configuration
Request = require('request').Request
FakeHttpResponse = require('fake_http_response').FakeHttpResponse

describe 'ResizeScale', ->
  _resizer = null
  _newImage = null

  beforeEach ->
    _newImage = null
    _resizer = new ResizeScale

    config = new Configuration('./test/fixtures/minimal_config_with_override.json')
    request = new Request('/150x200/images/black_square.jpg', config)
    imageFile = new ImageOnFilesystem(config, new FakeHttpResponse)

    imageFile.open(request.path, ->
      _newImage = _resizer.resize(request, imageFile.data)
    )

    waitsFor ->
       _newImage?

  it 'should have a name', ->
    expect(_resizer.name).toEqual('scale')

  it 'should resize to given width', ->
    expect(_newImage.width).toEqual(150)

  it 'should resize to given height', ->
    expect(_newImage.height).toEqual(150)
