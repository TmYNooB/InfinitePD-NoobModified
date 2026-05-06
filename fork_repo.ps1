
# GitHub Fork & Repo Creation Script
$token = $env:GITHUB_TOKEN
if (-not $token) {
    $secureToken = Read-Host "GitHub Token (PAT)" -AsSecureString
    $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureToken)
    try {
        $token = [Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
    }
    finally {
        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
    }
}

if (-not $token) {
    Write-Host "❌ Kein GitHub Token angegeben. Setze GITHUB_TOKEN oder gib den Token beim Start ein." -ForegroundColor Red
    exit 1
}
$username = "TmYNooB"

$headers = @{
    "Authorization" = "Bearer $token"
    "Accept" = "application/vnd.github+json"
    "X-GitHub-Api-Version" = "2022-11-28"
}

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "GitHub Fork & Private Repo Setup" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# 1. Verify auth
Write-Host "`n[1/4] Überprüfe Authentifizierung..." -ForegroundColor Yellow
try {
    $userResp = Invoke-RestMethod -Uri "https://api.github.com/user" -Headers $headers
    $authUser = $userResp.login
    Write-Host "✓ Authentifiziert als: $authUser" -ForegroundColor Green
}
catch {
    Write-Host "❌ Auth fehlgeschlagen: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# 2. Create fork
Write-Host "`n[2/4] Erstelle Fork von DragonMaster14545/Infinite-Pixel-Dungeon..." -ForegroundColor Yellow
try {
    $forkUri = "https://api.github.com/repos/DragonMaster14545/Infinite-Pixel-Dungeon/forks"
    $forkResp = Invoke-RestMethod -Uri $forkUri -Method Post -Headers $headers -ContentType "application/json"
    $forkFullName = $forkResp.full_name
    $forkUrl = $forkResp.html_url
    Write-Host "✓ Fork erstellt: $forkFullName" -ForegroundColor Green
    Write-Host "  URL: $forkUrl" -ForegroundColor Cyan
}
catch {
    Write-Host "❌ Fork fehlgeschlagen: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# 3. Wait for GitHub processing
Write-Host "`n[3/4] Warte auf GitHub-Verarbeitung (15 Sekunden)..." -ForegroundColor Yellow
Start-Sleep -Seconds 15

# 4. Create private repo
Write-Host "`n[4/4] Erstelle privates Repo 'InfinitePD-NoobModified'..." -ForegroundColor Yellow
try {
    $repoData = @{
        name = "InfinitePD-NoobModified"
        description = "Modified fork of Infinite Pixel Dungeon"
        private = $true
        has_issues = $true
        has_projects = $true
        has_downloads = $true
    } | ConvertTo-Json

    $repoUri = "https://api.github.com/user/repos"
    $repoResp = Invoke-RestMethod -Uri $repoUri -Method Post -Headers $headers -Body $repoData -ContentType "application/json"
    $privateRepoUrl = $repoResp.html_url
    Write-Host "✓ Privates Repo erstellt: InfinitePD-NoobModified" -ForegroundColor Green
    Write-Host "  URL: $privateRepoUrl" -ForegroundColor Cyan
}
catch {
    Write-Host "⚠ Private Repo fehlgeschlagen: $($_.Exception.Message)" -ForegroundColor Red
}

# Summary
Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host "✓ SETUP ABGESCHLOSSEN!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "`nFork URL:"
Write-Host "  https://github.com/$username/Infinite-Pixel-Dungeon" -ForegroundColor Cyan

Write-Host "`nNächste Schritte:"
Write-Host "  1. Aktualisiere lokales Git Repository:" -ForegroundColor Yellow
Write-Host "     git remote set-url origin https://github.com/$username/Infinite-Pixel-Dungeon.git"
Write-Host "  2. Push to Fork:" -ForegroundColor Yellow
Write-Host "     git push -u origin main"

Write-Host "`n✓ Starte nun Konfiguration..." -ForegroundColor Green
