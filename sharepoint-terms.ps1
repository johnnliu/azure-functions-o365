Import-Module "D:\home\site\wwwroot\modules\SharePointPnPPowerShellOnline.psd1" -global

$requestBody = Get-Content $req -Raw | ConvertFrom-Json

#Get-Command -Module *PnP*
#Feb 2017

$username = "service@johnliu365.onmicrosoft.com";
$password = $env:PW;
$siteUrl = "https://johnliu365.sharepoint.com"

$secpasswd = ConvertTo-SecureString $password -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential ($username, $secpasswd)

"try connect to $siteUrl"
Connect-PnPOnline -url $siteUrl -Credentials $creds 

$terms = Get-PnPTerm -TermSet "Location" -TermGroup "People"

$names = $terms | select-object "Name"
$names

Out-File -Encoding Ascii -FilePath $res -inputObject ($names | ConvertTo-Json)
