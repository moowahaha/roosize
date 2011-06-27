gd = require 'node-gd'
http = require 'http'
spawn = require('child_process').spawn
assert = require 'assert'

testImage = (image) ->
  assertResponse(image.width, 800, 'width is correct')
  assertResponse(image.height, 600, 'height is correct')

RoosizeServer = null
Passed = true

assertResponse = (got, expected, message) ->
  process.stdout.write message + '... '

  try
    assert.equal(got, expected)
    process.stdout.write("PASS\n")
  catch error
    if error.name is 'AssertionError'
      console.log(error)
      Passed = false
      process.stdout.write("FAIL (expected: " + expected + ", got: " + got + ")\n")
    else
      RoosizeServer.kill 'SIGTERM'
      throw error

killServer = (code) ->
  console.warn('ERROR: failed to start roosize')
  process.exit(code)

makeRequest = ->
  roosizeClient = http.createClient 8080, 'localhost'
  image = null

  request = roosizeClient.request(
    'GET', '/800x600/bob.jpg',
    {'host': 'localhost'}
  )

  request.end()

  request.on 'response', (response) ->
    response.setEncoding('binary')
    data = ''

    response.on 'data', (chunk) ->
      data += chunk

    response.on 'end', ->
      testImage(gd.createFromJpegPtr(data))
      RoosizeServer.removeListener 'exit', killServer
      RoosizeServer.kill 'SIGTERM'
      process.exit(Passed is false)

startServer = ->
  RoosizeServer = spawn('coffee', ['roosize.coffee', './test/fixtures/minimal_config.json']);

  RoosizeServer.stdout.on 'data', (data) ->
    if data.toString().match(/Listening/)
      makeRequest()

  RoosizeServer.on 'exit', killServer


startServer()