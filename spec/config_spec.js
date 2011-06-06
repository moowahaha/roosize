var Configuration = require('config').Configuration;

describe('Configuration', function () {
    var _config;

    beforeEach(function () {
        _config = new Configuration('./spec/fixtures/full_config.json');
    });

    it('should have a root', function () {
        expect(_config.root).toEqual('/tmp');
    });
});
