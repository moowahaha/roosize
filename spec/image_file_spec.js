var ImageFile = require('image_file').ImageFile,
        Configuration = require('config').Configuration,
        fs = require('fs');

describe('Server', function () {
    var _imageFile;

    beforeEach(function () {
        _imageFile = new ImageFile(new Configuration('./spec/fixtures/full_config.json'));
        _imageFile.open('images/bob.jpg');
    });

    it('should have a modified time', function () {
        var modified = fs.statSync('./spec/fixtures/images/bob.jpg')['mtime'];
        expect(modified).toBeLessThan(new Date);
        expect(_imageFile.modified).toEqual(modified);
    });

    describe('file format', function () {
        it('should have a stringified type', function () {
            expect(_imageFile.type).toEqual('jpeg');
        });

        it('should have a mime type', function () {
            expect(_imageFile.mimeType).toEqual('image/jpeg');
        });
    });

    it('should have some image data', function () {
        expect(_imageFile.data.width).toEqual(450);
        expect(_imageFile.data.height).toEqual(348);
    });
});
