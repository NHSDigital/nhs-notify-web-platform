exports.handler = (event, context, callback) => {
  // console.log("Event", JSON.stringify(event));

  const request = event.Records[0].cf.request;
  const response = event.Records[0].cf.response;
  const requestUri = request.uri;
  const requestHost = request.headers.host[0].value;

   // Check if the response is a redirect (status code 301 or 302)
   if (response.status === '301' || response.status === '302') {
      const headers = response.headers;
       // Check if the Location header exists
       if (headers['location'] && headers['location'][0].value) {
           let location = headers['location'][0].value;
           // If the Location rewrites the trailing slash
           if (location.endsWith(`${requestUri}/`)) {
               // Rewrite the Location header to point to the CloudFront domain
               headers['location'][0].value = `https://${requestHost}${requestUri}/`;
           }
       }
   }
  // Return the modified or unmodified response
  return callback(null, response);
};
