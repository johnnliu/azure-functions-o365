/*
    To talk to SharePoint Online via App-Only permissions you'll need client id and client certificate.
    The certificate can be self signed.  You'll need to upload it to your function (mine is funky.pem)

    http://johnliu.net/blog/2016/5/azure-functions-js-and-app-only-updates-to-sharepoint-online

    To extend this code with SharePoint WebHooks, see:

    http://johnliu.net/blog/2016/9/working-with-sharepoint-webhooks-with-javascript-using-an-azure-function

    function settings > Kudu > navigate to function folder under sites
    > npm init -y
    > npm install node-fetch adal-node --save

*/

var fetch = require("node-fetch");
var adal = require("adal-node")
var fs = require("fs")

module.exports = function(context, req) {
    context.log('Node.js HTTP trigger function processed a request. RequestUri=%s', req.originalUrl);

    var resource = 'https://johnliu365.sharepoint.com';
    var authorityHostUrl = 'https://login.microsoftonline.com';
    var tenant = 'johnliu365.onmicrosoft.com';
    var authorityUrl = authorityHostUrl + '/' + tenant;
    var clientId = process.env['ClientId']; 
    var thumbprint = process.env['ThumbPrint']; 
    var certificate = fs.readFileSync(__dirname + '/funky.pem', { encoding : 'utf8'});
    
    var authContext = new adal.AuthenticationContext(authorityUrl);

    authContext.acquireTokenWithClientCertificate(resource, clientId, certificate, thumbprint, function(err, tokenResponse) {
        if (err) {
            context.log('well that didn\'t work: ' + err.stack);
            context.done();
        } else {

            var accesstoken = tokenResponse.accessToken;
            
            context.log(accesstoken);
            context.done();

            // var query = "john";
            // if (req.body){
            //     query = encodeURIComponent(req.body.name);
            // }

            // var uri = "https://johnliu365.sharepoint.com/_api/search/query?querytext='" + query + "'"; 
            // var options = {
            //     method: "GET",
            //     headers: {
            //         'Authorization': 'Bearer ' + accesstoken, 
            //         'Accept': 'application/json; odata=verbose',
            //         'Content-Type': 'application/json; odata=verbose'
            //     }
            // };

            // context.log(options);
            // fetch(uri, options)
            // .then(function(res){
            //     return res.json();
            // })
            // .then(function(body){
            //     context.log(JSON.stringify(body));
            //     var results = body.d.query.PrimaryQueryResult.RelevantResults.Table.Rows.results;
            //     context.log(results.length);
            //     //context.$return = { body: body || '' };
            //     context.done(null, results);
            // })
            // .catch(function(error){
            //     context.log(error);
            // });
        }
    });
};