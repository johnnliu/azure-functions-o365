#
# This demo requires the PnP-PowerShell libraries to be deployed in modules folder
#
# johnliu.net/blog/2016/11/build-your-pnp-site-provisioning-with-powershell-in-azure-functions-and-run-it-from-flow
#

$requestBody = Get-Content $req -Raw | ConvertFrom-Json

$username = "service@johnliu365.onmicrosoft.com";
$password = $env:PW;
$siteUrl = "https://johnliu365.sharepoint.com"

$secpasswd = ConvertTo-SecureString $password -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential ($username, $secpasswd)

"try connect to $siteUrl"
Connect-PnPOnline -url $siteUrl -Credentials $creds 

# $items = Get-PnPListItem -list "Documents" 

$items = Get-PnPListItem -List "Documents" -Query "<View><Query><Where><IsNotNull><FieldRef Name='CheckoutUser'/></IsNotNullEq></Where></Query></View>"

"found: " + $items.length

$items | % {

    #$_.FieldValues  | ConvertTo-Json 

    $url = $_.FieldValues["FileRef"]
    Set-PnPFileCheckedIn -Url $url -Comment "checked in via Function"
}

Out-File -Encoding Ascii -FilePath $res -inputObject "Done"
