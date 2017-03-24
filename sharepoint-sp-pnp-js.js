/*
    function settings > Kudu > navigate to function folder under sites
    > npm init -y
    > npm install sp-pnp-js node-sp-auth node-fetch --save-dev

    see sharepoint-sp-pnp-js.package.json

    pretty much follows @mediocrebowler
    https://blogs.msdn.microsoft.com/patrickrodgers/2016/10/17/using-pnp-js-core-and-node-sp-auth/

    node-sp-auth @sergeev_srg does crazy authentication including returning federated cookie header for
    username/password pairs 

*/

var pnp = require("sp-pnp-js");
var auth = require("node-sp-auth");
var fetch = require("node-fetch");

//declare var global;
global.Headers = fetch.Headers;
global.Request = fetch.Request;
global.Response = fetch.Response;
global.fetch = fetch;

module.exports = function (context, req) {
    context.log('JavaScript HTTP trigger function processed a request.');

    var options = {
        username: "service@johnliu365.onmicrosoft.com",
        password: process.env["PW"]
    };
    var siteUrl = "https://johnliu365.sharepoint.com";

    auth.getAuth(siteUrl, options).then((response) => {
        // see this auth cookie?  It's madness        
        context.log(response);

        return new Promise(resolve => {
            // now we use the headers supplied by getAuth to set the global headers for the pnp library
            pnp.setup({
                headers: response.headers
            });
            resolve();
        });
    }).then(() => {

        // context.log(siteUrl);

        // we need to use the Web constructor to ensure we have the absolute url
        var web = new pnp.Web(siteUrl);
        web.select("Title").get().then(w => {
            // console.log(`Web's title: ${w.Title}`);
            res = {
                status: 200,
                body: w.Title
            };
            context.log("title:" + w.Title);
            context.done(null, res);
        });

    }).catch(function() {
        res = {
            status: 200,
            body: arguments
        };
        context.done(null, res);
    });

};