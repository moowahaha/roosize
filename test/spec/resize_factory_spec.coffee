Configuration = require('configuration').Configuration
FakeHttpResponse = require('fake_http_response').FakeHttpResponse
Request = require('request').Request
resizeFactory = require('resize_factory')

describe 'resizeFactory', ->
  _fakeHttpResponse = null

  beforeEach ->
    _fakeHttpResponse = new FakeHttpResponse

  ['pad', 'stretch', 'scale', 'crop'].forEach (strategy) ->
    _config = null
    _request = null

    beforeEach ->
      _config = new Configuration('./test/fixtures/full_config.json')
      _request = new Request('/640x480/something/something?strategy=' + strategy, _config, _fakeHttpResponse)

    it 'should ' + strategy + ' our image', ->
      resizer = resizeFactory.instance(_config, _request, _fakeHttpResponse)
      expect(resizer.name).toEqual(strategy)

  it 'should use the default strategy', ->
    resizer = resizeFactory.instance(
        new Configuration('./test/fixtures/minimal_config.json'),
        new Request('/1x2/something/something', _fakeHttpResponse),
        _fakeHttpResponse
    )

    expect(resizer.name).toEqual('pad')

  it 'should reject an attempt to override the strategy and we are not allowed', ->
    resizeFactory.instance(
      new Configuration('./test/fixtures/minimal_config.json'),
      new Request('/1x2/something/something?Strategy=stretch', _fakeHttpResponse),
      _fakeHttpResponse
    )

    expect(_fakeHttpResponse.code).toEqual(403)
    expect(_fakeHttpResponse.body).toEqual('You cannot specify a strategy')

  it 'should reject an attempt to request an unknown strategy', ->
    resizeFactory.instance(
        new Configuration('./test/fixtures/full_config.json'),
        new Request('/640x480/something/something?strategy=something', _fakeHttpResponse),
        _fakeHttpResponse
    )

    expect(_fakeHttpResponse.code).toEqual(406)
    expect(_fakeHttpResponse.body).toEqual('Unknown strategy something')

  it 'should reject a request of an unsupported size', ->
    resizeFactory.instance(
        new Configuration('./test/fixtures/full_config.json'),
        new Request('/1x2/something/something', _fakeHttpResponse),
        _fakeHttpResponse
    )

    expect(_fakeHttpResponse.code).toEqual(403)
    expect(_fakeHttpResponse.body).toEqual('Requested size not supported')
