var ImageFile = require('image_file').ImageFile,
        Configuration = require('config').Configuration;

describe('Server', function () {
    var _imageFile;

    beforeEach(function () {
        _imageFile = new ImageFile(new Configuration('./spec/fixtures/full_config.json'));
        _imageFile.open('images/bob.jpg');
    });

    it('should have a modified time', function () {
        // very fragile test!
        expect(_imageFile.modified).toEqual(new Date('Tue Jun 07 2011 20:35:15 GMT+1000 (EST)'));
    });
});
