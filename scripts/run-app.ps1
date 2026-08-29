# MindTouch — starts API + Flutter app (Windows)
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$Client = Join-Path $Root "apps\client"

Write-Host "=== MindTouch ===" -ForegroundColor Cyan

# 1. Ensure API is running
$apiUp = $false
try {
  $r = Invoke-WebRequest -Uri "http://localhost:3000/api/health" -UseBasicParsing -TimeoutSec 2
  if ($r.StatusCode -eq 200) { $apiUp = $true }
} catch {}

if (-not $apiUp) {
  Write-Host "Starting API on port 3000..." -ForegroundColor Yellow
  Start-Process powershell -ArgumentList @(
    "-NoExit", "-Command",
    "cd '$Root'; npm start"
  ) -WindowStyle Minimized

  $deadline = (Get-Date).AddSeconds(20)
  do {
    Start-Sleep -Seconds 1
    try {
      $r = Invoke-WebRequest -Uri "http://localhost:3000/api/health" -UseBasicParsing -TimeoutSec 2
      if ($r.StatusCode -eq 200) { $apiUp = $true; break }
    } catch {}
  } while ((Get-Date) -lt $deadline)

  if (-not $apiUp) {
    Write-Host "API failed to start. Run 'npm start' manually in the project root." -ForegroundColor Red
    exit 1
  }
}
Write-Host "API ready: http://localhost:3000/admin" -ForegroundColor Green

# 2. Pick device
$device = "emulator-5554"
$devices = flutter devices --device-timeout 5 2>&1 | Out-String
if ($devices -notmatch "emulator-5554") {
  if ($devices -match "(emulator-\d+)") {
    $device = $Matches[1]
  } elseif ($devices -match "• (\S+) • android") {
    $device = ($devices | Select-String "• (\S+) • android").Matches[0].Groups[1].Value
  }
}

Write-Host "Launching app on $device ..." -ForegroundColor Cyan
Set-Location $Client
flutter run -d $device
