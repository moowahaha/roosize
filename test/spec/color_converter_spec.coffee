ColorConverter = require('color_converter').ColorConverter

describe 'ColorConverter', ->
  _converter = null

  beforeEach ->
    _converter = new ColorConverter

  it 'should convert a hex string to 3 integer values', ->
    expect(_converter.fromHex('FF00FF')).toEqual([255, 0, 255])

  it 'should convert an array of decimal into a hex string', ->
    expect(_converter.fromDecimal([0, 255, 0])).toEqual('00ff00')