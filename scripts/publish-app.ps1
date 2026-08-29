# Build release APK for distribution (same flow as other MindTouch projects)
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$Client = Join-Path $Root "apps\client"
$OutDir = Join-Path $Root "dist"

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

Write-Host "=== MindTouch App Build ===" -ForegroundColor Cyan
Set-Location $Client

Write-Host "Building release APK..." -ForegroundColor Yellow
flutter build apk --release

$Apk = Join-Path $Client "build\app\outputs\flutter-apk\app-release.apk"
if (Test-Path $Apk) {
  $Dest = Join-Path $OutDir "mindtouch-release.apk"
  Copy-Item $Apk $Dest -Force
  Write-Host "APK ready: $Dest" -ForegroundColor Green
} else {
  Write-Host "Build failed — APK not found" -ForegroundColor Red
  exit 1
}
