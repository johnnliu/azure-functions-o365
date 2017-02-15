#
# This demo does not have any DLL dependencies, using purely Invoke-WebRequest and Invoke-RestMethod
#
# http://johnliu.net/blog/2017/2/azurefunctions-powershell-ms-graph-and-apponly-permission
#
# You can pretty much use two cmdlets to crack open ANY microsoft graph API.  Please share your amazing creations.
#

$requestBody = Get-Content $req -Raw | ConvertFrom-Json
$name = $requestBody.name

$client_id = "44da3f20-fc0b-4f90-8bb1-54b1d50e3ecf";
$client_secret = $env:CS2;
$tenant_id = "26e65220-5561-46ef-9783-ce5f20489241";
$resource = "https://graph.microsoft.com";

$authority = "https://login.microsoftonline.com/$tenant_id";
$tokenEndpointUri = "$authority/oauth2/token";
$content = "grant_type=client_credentials&client_id=$client_id&client_secret=$client_secret&resource=$resource";

$response = Invoke-WebRequest -Uri $tokenEndpointUri -Body $content -Method Post -UseBasicParsing
$responseBody = $response.Content | ConvertFrom-JSON
$responseBody
$access_token = $responseBody.access_token

# GET https://graph.microsoft.io/en-us/docs/api-reference/v1.0/api/group_list
$body = Invoke-RestMethod -Uri "https://graph.microsoft.com/v1.0/groups" -Headers @{"Authorization" = "Bearer $access_token"}
$body | ConvertTo-JSON

# POST - this creates groups https://graph.microsoft.io/en-us/docs/api-reference/v1.0/api/group_post_groups
# $body = @{"displayName"= $name; "mailEnabled"=$false; "groupTypes"=@("Unified"); "securityEnabled"=$false; "mailNickname"=$name } | ConvertTo-Json 
# $body = Invoke-RestMethod `
#     -Uri "https://graph.microsoft.com/v1.0/groups" `
#     -Headers @{"Authorization" = "Bearer $access_token"} `
#     -Body $body `
#     -ContentType "application/json" `
#     -Method POST
# $body | ConvertTo-JSON

Out-File -Encoding Ascii -FilePath $res -inputObject $body
