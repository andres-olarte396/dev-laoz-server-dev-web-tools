# Script de prueba para dev-laoz-api-secrets
$baseUrl = "https://localhost:3501/api"
# Ignorar errores de certificado SSL autofirmado (Callback global por si acaso)
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }

$testApp = "TestAppName"
$testKey = "DB_PASSWORD"
$testValue = "SuperSecretPassword123!"

Write-Host "1. Testing Health Endpoint..." -ForegroundColor Cyan
try {
    # Usando -SkipCertificateCheck para PowerShell Core / modernos
    $health = Invoke-RestMethod -Uri "$baseUrl/health" -Method Get -SkipCertificateCheck
    Write-Host "   Health Status: $($health.status)" -ForegroundColor Green
}
catch {
    Write-Host "   Failed to connect to Health endpoint: $_" -ForegroundColor Red
}

Write-Host "`n2. Testing Create Secret..." -ForegroundColor Cyan
$bodyCreate = @{
    key   = $testKey
    value = $testValue
    app   = $testApp
} | ConvertTo-Json

try {
    $responseCreate = Invoke-RestMethod -Uri "$baseUrl/secrets" -Method Post -Body $bodyCreate -ContentType "application/json" -SkipCertificateCheck
    Write-Host "   Secret Created: $($responseCreate | ConvertTo-Json -Depth 1)" -ForegroundColor Green
}
catch {
    Write-Host "   Failed to create secret: $_" -ForegroundColor Red
    if ($_.Exception.Response) {
        Write-Host "   Error Details: $($_.Exception.Response.GetResponseStream() | %{ $_.ReadToEnd() })" -ForegroundColor Red
    }
}

Write-Host "`n3. Testing Get Secret..." -ForegroundColor Cyan
$bodyGet = @{
    key = $testKey
} | ConvertTo-Json

try {
    $responseGet = Invoke-RestMethod -Uri "$baseUrl/secrets/$testApp" -Method Post -Body $bodyGet -ContentType "application/json" -SkipCertificateCheck
    Write-Host "   Secret Retrieved: $($responseGet | ConvertTo-Json -Depth 1)" -ForegroundColor Green
    
    if ($responseGet.value -eq $testValue) {
        Write-Host "   [SUCCESS] Retrieved value matches created value." -ForegroundColor Green
    }
    else {
        Write-Host "   [FAILURE] Retrieved value does NOT match." -ForegroundColor Red
    }
}
catch {
    Write-Host "   Failed to get secret: $_" -ForegroundColor Red
}
