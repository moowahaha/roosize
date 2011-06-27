Request = require('request').Request
Configuration = require('configuration').Configuration

describe 'Request', ->
  _request = null

  beforeEach ->
    _request = new Request('/111x222/blah/some_file.png', new Configuration('./test/fixtures/minimal_config.json'))

  it 'should have a width', ->
    expect(_request.width).toEqual(111)

  it 'should have a height', ->
    expect(_request.height).toEqual(222)

  it 'should have a filename', ->
    expect(_request.path).toEqual('blah/some_file.png')