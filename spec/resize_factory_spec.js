var Configuration = require('config').Configuration,
        url = require('url'),
        ResizeFactory = require('resize_factory').ResizeFactory;

describe('ResizeFactory', function () {
    ['stretch'].forEach(function (strategy) {
//    ['pad', 'stretch', 'scale', 'crop'].forEach(function (strategy) {
        var _config, _url;
        beforeEach(function () {
            _url = url.parse('/something/something?strategy=' + strategy, true);
            _config = new Configuration('./spec/fixtures/full_config.json');
        });

        it('should ' + strategy + ' our image', function () {
            var resizeFactory = new ResizeFactory(_config, _url);
            expect(resizeFactory.instance.name).toEqual(strategy)
        });
    });

    it('should use the default strategy', function () {
        var resizeFactory = new ResizeFactory(
                new Configuration('./spec/fixtures/minimal_config.json'),
                url.parse('/something/something', true)
                );

        expect(resizeFactory.instance.name).toEqual('pad')
    });

    it('should throw an exception when we try to override the strategy and we are not allowed', function () {
        var errorThrown = false;

        try {
            new ResizeFactory(
                    new Configuration('./spec/fixtures/minimal_config.json'),
                    url.parse('/something/something?strategy=stretch', true)
                    )

        } catch (err) {
            if (err['name'] == 'EPERM') {
                errorThrown = true;
            }
            else {
                throw err;
            }
        }

        expect(errorThrown).toBeTruthy();
    });

    it('should throw en exception when requesting unknown strategy', function () {
        var errorThrown = false;

        try {
            new ResizeFactory(
                    new Configuration('./spec/fixtures/full_config.json'),
                    url.parse('/something/something?strategy=something', true)
                    )

        } catch (err) {
            if (err['name'] == 'EPERM') {
                errorThrown = true;
            }
            else {
                throw err;
            }
        }

        expect(errorThrown).toBeTruthy();
    });

});