#
# This demo requires the PnP-PowerShell libraries to be deployed in modules folder
#
# johnliu.net/blog/2016/11/build-your-pnp-site-provisioning-with-powershell-in-azure-functions-and-run-it-from-flow
#

$requestBody = Get-Content $req -Raw | ConvertFrom-Json
$url = $requestBody.url
$title = $requestBody.title
$desc = $requestBody.desc

$username = "service@johnliu365.onmicrosoft.com";
$password = $env:PW;
$root = "https://johnliu365.sharepoint.com"

$secpasswd = ConvertTo-SecureString $password -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential ($username, $secpasswd)

# https://github.com/SharePoint/PnP
# https://github.com/SharePoint/PnP-PowerShell

$templateUrl = "$root/template"
$siteUrl = "$root/$url"

try {
    "try connect to $siteUrl"
    Connect-PnPOnline -url $siteUrl -Credentials $creds 
    $web = Get-PnPWeb 
}
catch {
    "doesn't exist - connect to $root then create it"
    Connect-PnPOnline -url $root -Credentials $creds 
    "make web $url under $root"
    $web = New-PnPWeb -Title $title -Description $desc -Url $url -Template "STS#0"
}

if($web -ne $null) {
    #Connect-PnPOnline -url $templateUrl -Credentials $creds 
    #$siteTemplate = Get-PnPProvisioningTemplate -OutputInstance    
    #Get-PnPProvisioningTemplate -Out "D:\home\site\wwwroot\demo2-sites-create\site-template1.xml"

    "apply template to $siteUrl"
    #Connect-PnPOnline -url $siteUrl -Credentials $creds 
    Apply-PnPProvisioningTemplate -web $web -path "D:\home\site\wwwroot\demo2-sites-create\site-template.xml"  #replace this path with your function directory

    # http://johnliu.net/blog/2016/11/build-your-pnp-site-provisioning-with-powershell-in-azure-functions-and-run-it-from-flow
    # https://github.com/SharePoint/PnP-Guidance/blob/551b9f6a66cf94058ba5497e310d519647afb20c/articles/Introducing-the-PnP-Provisioning-Engine.md
    # https://msdn.microsoft.com/en-us/pnp_articles/pnp-remote-provisioning
}

Out-File -Encoding Ascii -FilePath $res -inputObject "Done $siteUrl"
