exports.ColorConverter = ->
  toHex = (num) ->
    str = num.toString(16)
    str = '0' + str if str.length < 2
    str

  fromHex: (hex) ->
    [
      parseInt(hex.substring(0, 2), 16),
      parseInt(hex.substring(2, 4), 16),
      parseInt(hex.substring(4, 6), 16)
    ]

  fromDecimal: (arr) ->
    toHex(arr[0]) + toHex(arr[1]) + toHex(arr[2])