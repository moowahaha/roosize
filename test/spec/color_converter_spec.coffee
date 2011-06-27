converter = require('color_converter')

describe 'ColorConverter', ->
  it 'should convert a hex string to 3 integer values', ->
    expect(converter.fromHex('FF00FF')).toEqual([255, 0, 255])

  it 'should convert an array of decimal into a hex string', ->
    expect(converter.fromDecimal([0, 255, 0])).toEqual('00ff00')