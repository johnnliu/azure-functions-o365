Import-Module "D:\home\site\wwwroot\modules\SharePointPnPPowerShellOnline.psd1" -Global;

$requestBody = Get-Content $req -Raw | ConvertFrom-Json
$name = $requestBody.name

$client_id = "c5cdb848-e7c6-42a5-824e-504c6f0b20c4";
$client_secret = $env:CS3;
$tenant = "johnliu365.onmicrosoft.com";

#march 2017 @mikaelsvenson 

Connect-PnPMicrosoftGraph `
    -AppId $client_id `
    -AppSecret $client_secret `
    -AADDomain $tenant

# see token for fun
Get-PnPAccessToken

$group = Get-PnPUnifiedGroup -Identity "$name"
$group | ConvertTo-Json

Out-File -Encoding Ascii -FilePath $res -inputObject ""
