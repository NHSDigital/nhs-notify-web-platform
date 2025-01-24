const lambdaHandler = require('../index.js');

const createEvent = (request, response) => ({
  Records: [
    {
      cf: {
        request,
        response,
      },
    },
  ],
});

describe("Lambda@Edge handler", () => {
  it("should return the original response if status is not 301 or 302", (done) => {
    const event = createEvent(
      { uri: "/test", headers: { host: [{ value: "example.com" }] } },
      { status: "200", headers: {} }
    );

    lambdaHandler.handler(event, {}, (err, response) => {
      expect(err).toBeNull();
      expect(response).toEqual(event.Records[0].cf.response);
      done();
    });
  });

  it("should not modify the Location header if it does not end with a trailing slash", (done) => {
    const event = createEvent(
      { uri: "/test", headers: { host: [{ value: "example.com" }] } },
      {
        status: "301",
        headers: {
          location: [{ value: "https://otherdomain.com/test" }],
        },
      }
    );

    lambdaHandler.handler(event, {}, (err, response) => {
      expect(err).toBeNull();
      expect(response.headers.location[0].value).toBe("https://otherdomain.com/test");
      done();
    });
  });

  it("should rewrite the Location header if it ends with a trailing slash", (done) => {
    const event = createEvent(
      { uri: "/test", headers: { host: [{ value: "example.com" }] } },
      {
        status: "301",
        headers: {
          location: [{ value: "https://otherdomain.com/test/" }],
        },
      }
    );

    lambdaHandler.handler(event, {}, (err, response) => {
      expect(err).toBeNull();
      expect(response.headers.location[0].value).toBe("https://example.com/test/");
      done();
    });
  });

  it("should not modify the response if the Location header is missing", (done) => {
    const event = createEvent(
      { uri: "/test", headers: { host: [{ value: "example.com" }] } },
      { status: "301", headers: {} }
    );

    lambdaHandler.handler(event, {}, (err, response) => {
      expect(err).toBeNull();
      expect(response).toEqual(event.Records[0].cf.response);
      done();
    });
  });
});
