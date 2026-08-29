# MindTouch — starts local API (fallback) + Flutter app
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$Client = Join-Path $Root "apps\client"

Write-Host "=== MindTouch ===" -ForegroundColor Cyan
Write-Host "Cloud: tries https://mindtouch.vercel.app first, falls back to local API" -ForegroundColor DarkGray

$apiUp = $false
try {
  $r = Invoke-WebRequest -Uri "http://localhost:3000/api/health" -UseBasicParsing -TimeoutSec 2
  if ($r.StatusCode -eq 200) { $apiUp = $true }
} catch {}

if (-not $apiUp) {
  Write-Host "Starting local API fallback on port 3000..." -ForegroundColor Yellow
  Start-Process powershell -ArgumentList @("-NoExit", "-Command", "cd '$Root'; npm start") -WindowStyle Minimized
  $deadline = (Get-Date).AddSeconds(25)
  do {
    Start-Sleep -Seconds 1
    try {
      $r = Invoke-WebRequest -Uri "http://localhost:3000/api/health" -UseBasicParsing -TimeoutSec 2
      if ($r.StatusCode -eq 200) { $apiUp = $true; break }
    } catch {}
  } while ((Get-Date) -lt $deadline)
}

if ($apiUp) {
  Write-Host "Local API ready: http://localhost:3000/admin" -ForegroundColor Green
} else {
  Write-Host "Local API not ready — app will use Vercel if deployed." -ForegroundColor Yellow
}

$device = "emulator-5554"
$devices = flutter devices --device-timeout 8 2>&1 | Out-String
if ($devices -notmatch "emulator-5554") {
  if ($devices -match "(emulator-\d+)") { $device = $Matches[1] }
}

Write-Host "Launching on $device ..." -ForegroundColor Cyan
Set-Location $Client
flutter run -d $device
