# azure-functions-o365

filename | notes
---      | ---
msgraph-create-group.ps1 | this function uses basic Invoke-WebRequest with clientid/clientsecret to acquire app-only permission to access Groups on MSGraph.  Same approach for most endpoints on MSGraph.
sharepoint-create-site.ps1 | this function uses PnP-PowerShell to create SharePoint sites and provision them with template.
sharepoint-library-checkin.ps1 | this function uses PnP-PowerShell to find checkedout files in a library and check them all in
sharepoint-search.js | this function uses adal-node with clientid/clientcertificate to acquire app-only permission to SharePoint Online.

# What about delegate permission

The only delegate permission example I have is via Resource Owner grant (password grant): 
http://johnliu.net/blog/2017/1/create-many-o365-groups-with-powershell-resource-owner-granttype-and-microsoft-graph

For more general purpose scenario - impersonate the current user via delegate, you'll need essentially several functions to capture and store access token via the consent dialog, and a blob storage to keep them.

Luckily, @dougware has built such a set of library available at:

https://github.com/InstantQuick/AzureFunctionsForSharePoint
