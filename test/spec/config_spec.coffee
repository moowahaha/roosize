Configuration = require('config').Configuration

describe 'Configuration', ->
  _config = null

  beforeEach ->
    _config = new Configuration('./test/fixtures/full_config.json')

  it 'should have a listenPort', ->
    expect(_config.listenPort).toEqual(8080)

  it 'should have a connectionLimit', ->
    expect(_config.connectionLimit).toEqual(200)

  describe 'cacheControl', ->
    it 'should have an inboundTTL', ->
      expect(_config.cacheControl.inboundTTL).toEqual(5);

    it 'should have an outboundTTL', ->
      expect(_config.cacheControl.outboundTTL).toEqual(3600);

  describe 'imageSource', ->
    it 'should have a path', ->
      expect(_config.imageSource.path).toEqual('./test/fixtures')

    it 'should have a type', ->
      expect(_config.imageSource.type).toEqual('filesystem')

  describe 'requestDefaults', ->
    it 'should have paddingColor', ->
      expect(_config.requestDefault('paddingcolor').allowOverride).toBeTruthy()
      expect(_config.requestDefault('paddingcolor').value).toEqual('6600AA')

    it 'should have resize strategy', ->
      expect(_config.requestDefault('Strategy').allowOverride).toBeTruthy()
      expect(_config.requestDefault('strategY').value).toEqual('stretch')

  describe 'limits', ->
    [
      {
        width: 200,
        height: 400,
        allowed: false

      },
      {
        width: 640,
        height: 480,
        allowed: true
      },
      {
        width: 700,
        height: 550,
        allowed: false
      },
      {
        width: 800,
        height: 600,
        allowed: true
      },
      {
        width: 3200,
        height: 2400,
        allowed: false
      }
    ].forEach (expectation) ->
      it 'should' + expectation.allowed ? ' ' : ' not ' + 'allow ' + expectation.width + 'x' + expectation.height, ->
        expect(
          _config.sizeWithinLimit(
            expectation.width,
            expectation.height
          )
        ).toEqual(expectation.allowed)

describe 'default configuration', ->
  _config = null

  beforeEach ->
    _config = new Configuration './test/fixtures/minimal_config.json'

  it 'should have a connectionLimit', ->
    expect(_config.connectionLimit).toEqual(5)

  describe 'cacheControl', ->
    it 'should have an inboundTTL', ->
      expect(_config.cacheControl.inboundTTL).toEqual(0)

    it 'should have an outboundTTL', ->
      expect(_config.cacheControl.outboundTTL).toEqual(0)

  describe 'requestDefaults', ->
    it 'should have paddingColor', ->
      expect(_config.requestDefault('paddingcolor').allowOverride).toBeFalsy()
      expect(_config.requestDefault('paddingcolor').value).toEqual('FFFFFF')

    it 'should have resize strategy', ->
      expect(_config.requestDefault('Strategy').allowOverride).toBeFalsy()
      expect(_config.requestDefault('strategY').value).toEqual('pad')

  it 'should accept any requested size', ->
    expect(_config.sizeWithinLimit(123456, 987654)).toBeTruthy()

