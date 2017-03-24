Import-Module "D:\home\site\wwwroot\modules\SharePointPnPPowerShellOnline.psd1" -Global;

$requestBody = Get-Content $req -Raw | ConvertFrom-Json
$source = $requestBody.source
$destination = $requestBody.destination

$username = "service@johnliu365.onmicrosoft.com";
$password = $env:PW;
$siteUrl = "https://johnliu365.sharepoint.com"

$secpasswd = ConvertTo-SecureString $password -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential ($username, $secpasswd)

"try connect to $siteUrl"
Connect-PnPOnline -url $siteUrl -Credentials $creds 

$items = Get-PnPListItem -List $source

$items | % {
    
    Copy-PnPFile `
        -SourceUrl $_.FieldValues.FileRef `
        -TargetUrl ($destination + "/" + $_.FieldValues.FileLeafRef) `
        -OverwriteIfAlreadyExists  `
        -Force 

    "copied $($_.FieldValues.FileLeafRef)"
} 

Out-File -Encoding Ascii -FilePath $res -inputObject "done"
