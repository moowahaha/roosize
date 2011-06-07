var Configuration = require('config').Configuration;

describe('Configuration', function () {
    var _config;

    beforeEach(function () {
        _config = new Configuration('./spec/fixtures/full_config.json');
    });

    it('should have a listenPort', function () {
        expect(_config.listenPort).toEqual(8080);
    });

    it('should have a connectionLimit', function () {
        expect(_config.connectionLimit).toEqual(200);
    });

    describe('cacheControl', function () {
        it('should have an inboundTTL', function () {
            expect(_config.cacheControl.inboundTTL).toEqual(5);
        });

        it('should have an outboundTTL', function () {
            expect(_config.cacheControl.outboundTTL).toEqual(3600);
        });
    });

    describe('imageSource', function () {
        it('should have a path', function () {
            expect(_config.imageSource.path).toEqual('./spec/fixtures');
        });

        it('should have a type', function () {
            expect(_config.imageSource.type).toEqual('filesystem');
        });
    });

    describe('requestDefaults', function() {
        it('should have paddingColor', function () {
            expect(_config.requestDefault('paddingcolor').allowOverride).toBeTruthy();
            expect(_config.requestDefault('paddingcolor').value).toEqual('6600AA');
        });

        it('should have resize strategy', function () {
            expect(_config.requestDefault('Strategy').allowOverride).toBeFalsy();
            expect(_config.requestDefault('strategY').value).toEqual('pad');
        });
    });

    describe('limits', function () {
        [
            {
                width: 200,
                height: 400,
                allowed: false

            },
            {
                width: 640,
                height: 480,
                allowed: true
            },
            {
                width: 700,
                height: 550,
                allowed: false
            },
            {
                width: 800,
                height: 600,
                allowed: true
            },
            {
                width: 3200,
                height: 2400,
                allowed: false
            }
        ].forEach(function (expectation) {
            it('should' + expectation['allowed'] ? ' ' : ' not ' + 'allow ' + expectation['width'] + 'x' + expectation['height'], function() {
                expect(_config.sizeWithinLimit(
                    expectation['width'],
                    expectation['height']
                )).toEqual(expectation['allowed']);
            });
        });

    });
});
