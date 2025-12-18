$baseUrl = "http://localhost:3210/api"
$filesUrl = "$baseUrl/files"

Write-Host "1. Login..."
$loginBody = @{
    username = "admin"
    password = "Admin123!"
} | ConvertTo-Json

try {
    $loginResp = Invoke-RestMethod -Uri "$baseUrl/auth/login" -Method Post -Body $loginBody -ContentType "application/json"
    $token = $loginResp.token
    Write-Host "Token obtained: $($token.Substring(0, 10))..."
}
catch {
    Write-Error "Login failed: $_"
    exit 1
}

$headers = @{
    Authorization = "Bearer $token"
}

Write-Host "2. Upload File..."
$dummyContent = "Hello ApiFiles World"
$dummyFile = "test_upload.txt"
Set-Content $dummyFile $dummyContent

# Uploading via curl to handle multipart easily
$boundary = "------------------------boundary123"
$LF = "`r`n"
$bodyLines = (
    "--$boundary",
    "Content-Disposition: form-data; name=`"file`"; filename=`"$dummyFile`"",
    "Content-Type: text/plain",
    "",
    "$dummyContent",
    "--$boundary--"
) -join $LF

try {
    # Using node script for upload might be easier or curl
    # Let's try direct curl command invocation
    $uploadRespJson = curl.exe -s -X POST "$filesUrl/upload" -H "Authorization: Bearer $token" -F "file=@$dummyFile"
    $uploadResp = $uploadRespJson | ConvertFrom-Json
    $fileId = $uploadResp.id
    Write-Host "File Uploaded. ID: $fileId"
}
catch {
    Write-Error "Upload failed: $_"
    exit 1
}

Write-Host "3. Get Versions..."
$versions = Invoke-RestMethod -Uri "$filesUrl/$fileId/versions" -Headers $headers
Write-Host "Versions: $($versions | ConvertTo-Json -Depth 2)"

Write-Host "4. Move File..."
$moveBody = @{
    targetStorageType = "LOCAL"
    targetPath        = "archive/moved_test.txt"
} | ConvertTo-Json

$moveResp = Invoke-RestMethod -Uri "$filesUrl/$fileId/move" -Method Put -Headers $headers -Body $moveBody -ContentType "application/json"
Write-Host "Move Response: $($moveResp | ConvertTo-Json)"

Write-Host "5. Verify Move (Get Versions)..."
$versionsAfter = Invoke-RestMethod -Uri "$filesUrl/$fileId/versions" -Headers $headers
$currentPath = $versionsAfter[$versionsAfter.Count - 1].relativePath
Write-Host "Current Path: $currentPath"

if ($currentPath -eq "archive/moved_test.txt") {
    Write-Host "SUCCESS: File moved correctly."
}
else {
    Write-Error "FAILURE: Path did not update."
}

# Cleanup
Remove-Item $dummyFile
