var fs = require('fs');

exports.Configuration = function (filename) {
    function _assignRequestDefaults(object, hash) {
        object._defaults = {};

        object.requestDefault = function (lookupDefault) {
            return object._defaults[lookupDefault.toLowerCase()];
        };

        for (var defaultValueKey in (hash['requestDefaults'] || {})) {
            object._defaults[defaultValueKey.toLowerCase()] = new Object(hash['requestDefaults'][defaultValueKey]);
        }
    }

    function _assignCacheControl(object, hash) {
        object.cacheControl = new Object({inboundTTL: 0, outboundTTL: 0});

        if (!hash['cacheControl']) {
            return;
        }

        object.cacheControl.inboundTTL = hash['cacheControl']['inboundTTL'] || 0;
        object.cacheControl.outboundTTL = hash['cacheControl']['outboundTTL'] || 0;
    }

    function _assignSizeLimits(object, hash) {
        object.sizeWithinLimit = function (strWidth, strHeight) {
            // just in case...
            var width = parseInt(strWidth);
            var height = parseInt(strHeight);

            var limits = object._limits;

            if (width > limits.maximumWidth || width < limits.minimumWidth || height > limits.maximumHeight || height < limits.minimumHeight) {
                return false;
            }

            if (Object.keys(limits.sizes) == 0 || limits.sizes[[width, height]]) {
                return true;
            }

            return false;
        };

        var _tmpLimits = {
            maximumWidth: Number.MAX_VALUE,
            maximumHeight: Number.MAX_VALUE,
            minimumWidth: Number.MIN_VALUE,
            minimumHeight: Number.MIN_VALUE,
            sizes: {}
        };

        var range = hash['limits']['range'];
        if (range) {
            ['maximum', 'minimum'].forEach(function (rangeType) {
                ['Width', 'Height'].forEach(function (dimension) {
                    var value = range[rangeType][dimension.toLowerCase()];

                    if (value) {
                        _tmpLimits[rangeType + dimension] = parseInt(value)
                    }
                });
            });
        }

        var sizes = hash['limits']['sizes'];
        if (sizes) {
            sizes.forEach(function (dimensions) {
                _tmpLimits['sizes'][[dimensions['width'], dimensions['height']]] = true;
            });
        }

        object._limits = new Object(_tmpLimits);
    }

    var configString = fs.readFileSync(filename, 'utf-8');
    var hash = JSON.parse(configString);

    this.imageSource = new Object(hash['imageSource']);
    this.listenPort = parseInt(hash['listenPort']);
    this.connectionLimit = parseInt(hash['connectionLimit']);

    _assignCacheControl(this, hash);
    _assignRequestDefaults(this, hash);
    _assignSizeLimits(this, hash);
}
