param(
    [string]$m = "",
    [switch]$WhatIf,
    [switch]$PullOnly
)

$ErrorActionPreference = "Stop"

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host " LocalSend Git Sync & Ecosystem Engine   " -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# 1. Pull latest changes
Write-Host "[1/3] Pulling remote updates..." -ForegroundColor Yellow
git pull --rebase --autostash origin main

if ($PullOnly) {
    Write-Host "Pull complete." -ForegroundColor Green
    exit 0
}

# 2. Check status
$status = git status --porcelain
if (-not $status) {
    Write-Host "[2/3] Working tree clean. Nothing to commit." -ForegroundColor Green
    exit 0
}

Write-Host "[2/3] Staging changes..." -ForegroundColor Yellow
git add -A

if (-not $m) {
    $m = "chore(sync): automated local updates"
}

if ($WhatIf) {
    Write-Host "[DRY RUN] Would commit: $m" -ForegroundColor Magenta
    git status
    exit 0
}

Write-Host "[3/3] Committing and pushing: $m" -ForegroundColor Yellow
git commit -m "$m"
git push origin main

Write-Host "=========================================" -ForegroundColor Green
Write-Host " LocalSend sync completed successfully!  " -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
