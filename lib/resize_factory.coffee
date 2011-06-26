ResizeStrategies =
    pad: require('resize/pad').ResizePad
    crop: require('resize/crop').ResizeCrop
    stretch: require('resize/stretch').ResizeStretch
    scale: require('resize/scale').ResizeScale

exports.ResizeFactory = (configuration, url) ->
    params =
        paddingcolor: configuration.requestDefault('paddingColor').value
        strategy: configuration.requestDefault('strategy').value

    Object.keys(url.query).forEach (key) ->
        key = key.toLowerCase()

        return if (!params[key])

        if (!configuration.requestDefault(key).allowOverride)
            throw {
                name: 'EPERM'
                message: 'You cannot specify ' + key
            }
            
        params[key] = url.query[key]

    if !ResizeStrategies[params.strategy]
        throw {
            name: 'EPERM'
            message: 'Unknown strategy ' + params.strategy
        }

    this.instance = new ResizeStrategies[params.strategy]
    
    return
