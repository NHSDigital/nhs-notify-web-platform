const lambdaHandler = require('../index.js');

describe('Lambda@Edge URI Rewriting', () => {
    let callback;
    let event;

    beforeEach(() => {
        callback = jest.fn();
        event = {
            Records: [
                {
                    cf: {
                        request: {
                            uri: ''
                        }
                    }
                }
            ]
        };
    });

    test('should rewrite URI to / if there is no second /', () => {
        event.Records[0].cf.request.uri = '/somepath';

        lambdaHandler.handler(event, {}, callback);

        expect(callback).toHaveBeenCalledWith(null, { uri: '/' });
    });

    test('should rewrite URI by removing the second segment', () => {
        event.Records[0].cf.request.uri = '/segment1/segment2/something';

        lambdaHandler.handler(event, {}, callback);

        expect(callback).toHaveBeenCalledWith(null, { uri: '/segment2/something' });
    });

    test('should rewrite URI correctly for root path', () => {
        event.Records[0].cf.request.uri = '/';

        lambdaHandler.handler(event, {}, callback);

        expect(callback).toHaveBeenCalledWith(null, { uri: '/' });
    });

    test('should handle URIs with multiple segments correctly', () => {
        event.Records[0].cf.request.uri = '/a/b/c/d';

        lambdaHandler.handler(event, {}, callback);

        expect(callback).toHaveBeenCalledWith(null, { uri: '/b/c/d' });
    });

    test('should handle URIs with no path correctly', () => {
        event.Records[0].cf.request.uri = '';

        lambdaHandler.handler(event, {}, callback);

        expect(callback).toHaveBeenCalledWith(null, { uri: '/' });
    });

    test('should handle mixed encoded and unencoded / characters', () => {
        event.Records[0].cf.request.uri = '/segment1/segment2%2Fsomething';

        lambdaHandler.handler(event, {}, callback);

        // Result should retain the encoded %2F in the result
        expect(callback).toHaveBeenCalledWith(null, { uri: '/segment2%2Fsomething' });
    });
});
