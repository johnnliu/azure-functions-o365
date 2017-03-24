# azure-functions-o365

filename | notes
---      | ---
msgraph-create-group.ps1 | this function uses basic Invoke-WebRequest with clientid/clientsecret to acquire app-only permission to access Groups on MSGraph.  Same approach for most endpoints on MSGraph.
sharepoint-create-site.ps1 | this function uses PnP-PowerShell to create SharePoint sites and provision them with template.
sharepoint-library-checkin.ps1 | this function uses PnP-PowerShell to find checkedout files in a library and check them all in
sharepoint-search.js | this function uses adal-node with clientid/clientcertificate to acquire app-only permission to SharePoint Online.
---      | ---
sample-swagger.json | this is a sample swagger.json file that you can use to see how to build one for yourself.  Swagger file is important for PowerApps and Flow to integrate well with Functions.
---      | ---
msgraph-create-group-pnp.ps1 | this function uses PnP-PowerShell (March 2017) to authenticate and talk to UnifiedGroups
sharepoint-list-email.ps1 | this function uses PnP-PowerShell to obtain list of documents, format to HTML table and send email summary
sharepoint-sp-pnp-js.js | this function uses PnP-JS-Core and Node-SP-Auth to authenticate then talk to SharePoint Online
sharepoint-terms.ps1 | this function uses PnP-PowerShell (Feb 2017) to obtain terms from SharePoint
sharepoint-copy-library.ps1 | this function uses PnP-PowerShell to copy one document library to another.  Note - 5min timeout applies to all functions.  Consider spliting list to Azure Queue and each copy is an individual Function.

# import-module

All scripts after Feb 2017 has been updated to re-use PnP-PowerShell module from a common shared directory.

Import-Module "D:\home\site\wwwroot\modules\SharePointPnPPowerShellOnline.psd1" -Global;

This simplifies updating the PnP cmdlets as well as keeping costs down on storage.  If your shared path is different, change that import accordingly.


# What about delegate permission

The only delegate permission example I have is via Resource Owner grant (password grant): 
http://johnliu.net/blog/2017/1/create-many-o365-groups-with-powershell-resource-owner-granttype-and-microsoft-graph

For more general purpose scenario - impersonate the current user via delegate, you'll need essentially several functions to capture and store access token via the consent dialog, and a blob storage to keep them.

Luckily, @dougware has built such a set of library available at:

https://github.com/InstantQuick/AzureFunctionsForSharePoint
