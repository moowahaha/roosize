var Configuration = require('config').Configuration;

describe('Configuration', function () {
    var _config;

    beforeEach(function () {
        _config = new Configuration('./spec/fixtures/full_config.json');
    });

    it('should have a listenPort', function () {
        expect(_config.listenPort).toEqual(8080);
    });

    describe('root', function () {
        it('should have a path', function () {
            expect(_config.root.path).toEqual('/tmp');
        });

        it('should have a type', function () {
            expect(_config.root.type).toEqual('directory');
        });
    });

    describe('requestDefaults', function() {
        it('should have paddingColor default', function () {
            expect(_config.requestDefault('paddingcolor').allowOverride).toEqual(true);
            expect(_config.requestDefault('paddingcolor').value).toEqual('6600AA');
        });

        it('should have resize strategy default', function () {
            expect(_config.requestDefault('Strategy').allowOverride).toEqual(false);
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
            it("should" + expectation['allowed'] ? ' ' : ' not ' + "allow " + expectation['width'] + 'x' + expectation['height'], function() {
                expect(_config.sizeWithinLimit(
                    expectation['width'],
                    expectation['height']
                )).toEqual(expectation['allowed']);
            });
        });

    });
});
