Configuration = require('config').Configuration
url = require 'url'
ResizeFactory = require('resize_factory').ResizeFactory

describe 'ResizeFactory', ->
  ['pad', 'stretch', 'scale', 'crop'].forEach (strategy) ->
    _config = null
    _url = null

    beforeEach ->
      _url = url.parse('/something/something?strategy=' + strategy, true)
      _config = new Configuration('./test/fixtures/full_config.json')

    it 'should ' + strategy + ' our image', ->
      resizeFactory = new ResizeFactory(_config, _url)
      expect(resizeFactory.instance.name).toEqual(strategy)

  it 'should use the default strategy', ->
    resizeFactory = new ResizeFactory(
        new Configuration('./test/fixtures/minimal_config.json'),
        url.parse('/something/something', true)
    )

    expect(resizeFactory.instance.name).toEqual('pad')

  it 'should throw an exception when we try to override the strategy and we are not allowed', ->
    errorThrown = false

    try
      new ResizeFactory(
        new Configuration('./test/fixtures/minimal_config.json'),
        url.parse('/something/something?strategy=stretch', true)
      )

    catch err
      if err.name == 'EPERM'
        errorThrown = true;
      else
        throw err
    finally
      expect(errorThrown).toBeTruthy()

  it 'should throw an exception when requesting unknown strategy', ->
    errorThrown = false

    try
      new ResizeFactory(
          new Configuration('./test/fixtures/full_config.json'),
          url.parse('/something/something?strategy=something', true)
          )

    catch err
      if (err.name == 'EPERM')
        errorThrown = true
      else
        throw err
    finally
      expect(errorThrown).toBeTruthy();