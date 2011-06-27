Request = require('request').Request
Configuration = require('configuration').Configuration
FakeHttpResponse = require('fake_http_response').FakeHttpResponse

describe 'Request', ->
  _request = null

  beforeEach ->
    _request = new Request(
      '/111x222/blah/some_file.png?name=bob&age=30',
      new Configuration('./test/fixtures/minimal_config.json'),
      new FakeHttpResponse
    )

  it 'should have a width', ->
    expect(_request.width).toEqual(111)

  it 'should have a height', ->
    expect(_request.height).toEqual(222)

  it 'should have a filename', ->
    expect(_request.path).toEqual('blah/some_file.png')

  it 'should have parameters', ->
    expect(_request.params.name).toEqual('bob')
    expect(_request.params.age).toEqual('30')

  it 'should set a response for an invalid request', ->
    fakeResponse = new FakeHttpResponse

    request = new Request(
      '/',
      new Configuration('./test/fixtures/minimal_config.json'),
      fakeResponse
    )

    expect(request.valid).toBeFalsy()
    expect(fakeResponse.code).toEqual(406)
    expect(fakeResponse.body).toEqual('Invalid resource: /')