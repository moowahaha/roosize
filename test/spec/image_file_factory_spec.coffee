imageFileFactory = require 'image_file_factory'
Configuration = require('configuration').Configuration
FakeHttpResponse = require('fake_http_response').FakeHttpResponse

describe 'ImageFileFactory', ->
  it 'should resolve to the filesystem when given an appropriate config', ->
    expect(imageFileFactory.instance(
      new Configuration('./test/fixtures/minimal_config.json'),
      new FakeHttpResponse
    ).name).toEqual('filesystem')

  it 'should resolve to the web when given an appropriate config', ->
    expect(imageFileFactory.instance(
      new Configuration('./test/fixtures/minimal_config_with_http.json'),
      new FakeHttpResponse
    ).name).toEqual('http')
