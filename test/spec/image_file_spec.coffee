ImageFile = require('image_file').ImageFile
Configuration = require('configuration').Configuration
FakeHttpResponse = require('fake_http_response').FakeHttpResponse
fs = require 'fs'

describe 'ImageFile', ->
  _imageFile = null
  beforeEach ->
    _imageFile = new ImageFile(new Configuration('./test/fixtures/full_config.json'), new FakeHttpResponse)
    _imageFile.open 'images/bob.jpg'

  it 'should have a modified time', ->
    modified = fs.statSync('./test/fixtures/images/bob.jpg').mtime
    expect(modified).toBeLessThan(new Date)
    expect(_imageFile.modified).toEqual(modified)

  describe 'file format', ->
    it('should have a stringified type', ->
      expect(_imageFile.type).toEqual('jpeg')
    )

    it('should have a mime type', ->
      expect(_imageFile.mimeType).toEqual('image/jpeg');
    )

  it 'should have some image data', ->
    expect(_imageFile.data.width).toEqual(450)
    expect(_imageFile.data.height).toEqual(348)

  it 'should respond with a 404 when an image is not found', ->
    fakeResponse = new FakeHttpResponse

    try
      imageFile = new ImageFile(new Configuration('./test/fixtures/minimal_config.json'), fakeResponse)
      imageFile.open 'images/does_not_exist.jpg'

    expect(fakeResponse.code).toEqual(404)
    expect(fakeResponse.body).toEqual('No such file on disk images/does_not_exist.jpg')