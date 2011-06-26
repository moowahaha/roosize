fs = require('fs')

exports.Configuration = (filename) ->
    _assignRequestDefaults = (object, hash) ->
        object._defaults =
            paddingcolor: new Object {
                allowOverride: false,
                value: 'FFFFFF'
            }
            strategy: new Object {
                value: "pad",
                allowOverride: false
            }

        object.requestDefault = (lookupDefault) ->
            object._defaults[lookupDefault.toLowerCase()]

        for defaultValueKey in (Object.keys(hash.requestDefaults || {}))
            do (defaultValueKey) ->
                object._defaults[defaultValueKey.toLowerCase()] = new Object hash.requestDefaults[defaultValueKey]

    _assignCacheControl = (object, hash) ->
        object.cacheControl = new Object {
            inboundTTL: 0,
            outboundTTL: 0
        }

        if !hash.cacheControl
            return

        object.cacheControl.inboundTTL = parseInt(hash.cacheControl.inboundTTL || 0)
        object.cacheControl.outboundTTL = parseInt(hash.cacheControl.outboundTTL || 0)

    _assignSizeLimits = (object, hash) ->
        object.sizeWithinLimit = (strWidth, strHeight) ->
            # just in case...
            width = parseInt(strWidth)
            height = parseInt(strHeight)

            limits = object._limits

            if (width > limits.maximumWidth || width < limits.minimumWidth || height > limits.maximumHeight || height < limits.minimumHeight)
                return false

            if (Object.keys(limits.sizes).length is 0 || limits.sizes[[width, height]])
                return true

            return false

        _tmpLimits =
            maximumWidth: Number.MAX_VALUE
            maximumHeight: Number.MAX_VALUE
            minimumWidth: Number.MIN_VALUE
            minimumHeight: Number.MIN_VALUE
            sizes: {}

        if hash.limits
            range = hash.limits.range
            if range
                ['maximum', 'minimum'].forEach (rangeType) ->
                    ['Width', 'Height'].forEach (dimension) ->
                        value = range[rangeType][dimension.toLowerCase()]

                        if (value)
                            _tmpLimits[rangeType + dimension] = parseInt(value)

            sizes = hash.limits.sizes
            if (sizes)
                sizes.forEach (dimensions) ->
                    _tmpLimits.sizes[[dimensions.width, dimensions.height]] = true


        object._limits = new Object _tmpLimits

    configString = fs.readFileSync filename, 'utf-8'
    hash = JSON.parse configString

    this.imageSource = new Object hash.imageSource
    this.listenPort = parseInt hash.listenPort
    this.connectionLimit = parseInt hash.connectionLimit || 5

    _assignCacheControl this, hash
    _assignRequestDefaults this, hash
    _assignSizeLimits this, hash
    return
