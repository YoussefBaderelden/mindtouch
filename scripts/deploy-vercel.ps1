# Deploy to Vercel and wire the Flutter app to the live URL
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$CloudUrlsFile = Join-Path $Root "apps\client\lib\core\config\cloud_urls.dart"

Set-Location $Root

Write-Host "=== MindTouch Vercel Deploy ===" -ForegroundColor Cyan

# Check login
$who = npx vercel whoami 2>&1
if ($LASTEXITCODE -ne 0) {
  Write-Host "Not logged in. Run: npx vercel login" -ForegroundColor Yellow
  npx vercel login
}

Write-Host "Deploying to production..." -ForegroundColor Yellow
$deployOutput = npx vercel deploy --prod --yes 2>&1 | Out-String
Write-Host $deployOutput

if ($deployOutput -match '(https://[\w-]+\.vercel\.app)') {
  $url = $Matches[1]
  Write-Host "Deployed: $url" -ForegroundColor Green

  $content = Get-Content $CloudUrlsFile -Raw
  $content = $content -replace "static const production = 'https://[^']+';", "static const production = '$url';"
  Set-Content $CloudUrlsFile $content -NoNewline

  Write-Host "Updated cloud_urls.dart -> $url" -ForegroundColor Green
  Write-Host ""
  Write-Host "Admin: $url/admin" -ForegroundColor Cyan
  Write-Host "API:   $url/api/health" -ForegroundColor Cyan
  Write-Host ""
  Write-Host "Next: Add Upstash Redis in Vercel Storage, then redeploy." -ForegroundColor Yellow
} else {
  Write-Host "Deploy finished — check output above for your URL." -ForegroundColor Yellow
}
