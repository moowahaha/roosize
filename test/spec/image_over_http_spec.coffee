ImageOverHttp = require('image_over_http').ImageOverHttp
Configuration = require('configuration').Configuration
FakeHttpResponse = require('fake_http_response').FakeHttpResponse

gd = require 'node-gd'
fs = require 'fs'

describe 'ImageOverHttp', ->
  _imageFile = null
  _fakeHttpResponse = new FakeHttpResponse
  _imageFile = new ImageOverHttp(new Configuration('./test/fixtures/minimal_config_with_http.json'), _fakeHttpResponse)
  _imageFile.open 'intl/en_com/images/srpr/logo1w.png', ->
    _imageFile.data

  beforeEach ->
    waitsFor ->
      _imageFile.data?

  it 'should have a modified time', ->
    # hack hack
    expect(_imageFile.modified).toEqual(new Date('Wed, 30 Jun 2010 21:36:48 GMT'))

  describe 'file format', ->
    it('should have a stringified type', ->
      expect(_imageFile.type).toEqual('png')
    )

    it('should have a mime type', ->
      expect(_imageFile.mimeType).toEqual('image/png');
    )

  it 'should have some image data', ->
    expect(_imageFile.data.width).toEqual(275)
    expect(_imageFile.data.height).toEqual(95)

  it 'should write back to the client', ->
    expect(_fakeHttpResponse.code).toEqual(200)
    expect(_fakeHttpResponse.headers['Content-Type']).toEqual('image/png')
    expect(gd.createFromPngPtr(_fakeHttpResponse.body).width).toEqual(275)

describe 'Missing ImageOverHttp', ->
  _fakeResponse = new FakeHttpResponse

  beforeEach ->
      imageFile = new ImageOverHttp(new Configuration('./test/fixtures/minimal_config_with_http.json'), _fakeResponse)
      imageFile.open 'images/does_not_exist.jpg'

      waitsFor ->
        _fakeResponse.code == 404

  it 'should respond with a 404 when an image is not found', ->
    expect(_fakeResponse.code).toEqual(404)
    expect(_fakeResponse.body).toEqual('No such file on remote host images/does_not_exist.jpg')