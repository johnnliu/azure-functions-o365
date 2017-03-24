Import-Module "D:\home\site\wwwroot\modules\SharePointPnPPowerShellOnline.psd1" -Global;

$requestBody = Get-Content $req -Raw | ConvertFrom-Json
$name = $requestBody.name

$username = "service@johnliu365.onmicrosoft.com";
$password = $env:PW;
$siteUrl = "https://johnliu365.sharepoint.com"

$secpasswd = ConvertTo-SecureString $password -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential ($username, $secpasswd)

"try connect to $siteUrl"
Connect-PnPOnline -url $siteUrl -Credentials $creds 

$items = Get-PnPListItem -List "Documents"

$mylist = @()

$items | % {

    $mylist += (new-object psobject -property @{
        File     = $_.FieldValues["FileLeafRef"]
        Editor   = $_.FieldValues["Editor"].LookupValue 
        Modified = $_.FieldValues["Last_x0020_Modified"]
    })

}

$mylist = $mylist | Sort-Object Modified -descending
$body = ($mylist | ConvertTo-HTML -Fragment -Property File, Editor, Modified )
$body = $body | out-string

Send-PnPMail -To "john.liu@johnliu365.onmicrosoft.com" -Subject "list library" -Body $body

Out-File -Encoding Ascii -FilePath $res -inputObject "Done $name" 
