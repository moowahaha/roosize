exports.FakeHttpResponse = ->
  headers: {}
  code: 0
  body: null

  end: (body) ->
    this.body = body

  writeHead: (code, headers) ->
    this.code = code
    this.headers = headers