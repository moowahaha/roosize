Configuration = require('configuration').Configuration
FakeHttpResponse = require('fake_http_response').FakeHttpResponse
Request = require('request').Request
ResizeFactory = require('resize_factory').ResizeFactory

describe 'ResizeFactory', ->
  _fakeHttpResponse = null

  beforeEach ->
    _fakeHttpResponse = new FakeHttpResponse

  ['pad', 'stretch', 'scale', 'crop'].forEach (strategy) ->
    _config = null
    _request = null

    beforeEach ->
      _config = new Configuration('./test/fixtures/full_config.json')
      _request = new Request('/1x2/something/something?strategy=' + strategy, _config, _fakeHttpResponse)

    it 'should ' + strategy + ' our image', ->
      resizeFactory = new ResizeFactory(_config, _request, _fakeHttpResponse)
      expect(resizeFactory.instance.name).toEqual(strategy)

  it 'should use the default strategy', ->
    resizeFactory = new ResizeFactory(
        new Configuration('./test/fixtures/minimal_config.json'),
        new Request('/1x2/something/something', _fakeHttpResponse),
        _fakeHttpResponse
    )

    expect(resizeFactory.instance.name).toEqual('pad')

  it 'should throw an exception when we try to override the strategy and we are not allowed', ->
    try
      new ResizeFactory(
        new Configuration('./test/fixtures/minimal_config.json'),
        new Request('/1x2/something/something?Strategy=stretch', _fakeHttpResponse),
        _fakeHttpResponse
      )

    expect(_fakeHttpResponse.code).toEqual(403)
    expect(_fakeHttpResponse.body).toEqual('You cannot specify a strategy')

  it 'should throw an exception when requesting unknown strategy', ->
    try
      new ResizeFactory(
          new Configuration('./test/fixtures/full_config.json'),
          new Request('/1x2/something/something?strategy=something', _fakeHttpResponse),
          _fakeHttpResponse
      )

    expect(_fakeHttpResponse.code).toEqual(406)
    expect(_fakeHttpResponse.body).toEqual('Unknown strategy something')
