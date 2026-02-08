# Setup submodules without Git - downloads ore-three and power-mesh from GitHub
# Uses exact commits matching next.junni.co.jp (2022-11)
$ErrorActionPreference = "Stop"
$projectRoot = $PSScriptRoot

$oreCommit = "b7615d8165a9e88b12a4399e24a2226d55931c94"
$pmCommit = "778512864b34635de9598a33b95c0d5137dfa659"

Write-Host "Downloading ore-three (commit $oreCommit)..." -ForegroundColor Cyan
$oreTemp = "$projectRoot\ore-three-temp.zip"
Invoke-WebRequest -Uri "https://github.com/ukonpower/ore-three/archive/$oreCommit.zip" -OutFile $oreTemp -UseBasicParsing

Write-Host "Extracting ore-three..." -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path "$projectRoot\packages" | Out-Null
if (Test-Path "$projectRoot\packages\ore-three") { Remove-Item "$projectRoot\packages\ore-three" -Recurse -Force }
$oreExtracted = "ore-three-$oreCommit"
if (Test-Path "$projectRoot\packages\$oreExtracted") { Remove-Item "$projectRoot\packages\$oreExtracted" -Recurse -Force }
Expand-Archive -Path $oreTemp -DestinationPath "$projectRoot\packages" -Force
Rename-Item -Path "$projectRoot\packages\$oreExtracted" -NewName "ore-three" -Force
Remove-Item $oreTemp -Force

Write-Host "Downloading power-mesh (commit $pmCommit)..." -ForegroundColor Cyan
$pmTemp = "$projectRoot\power-mesh-temp.zip"
Invoke-WebRequest -Uri "https://github.com/ukonpower/power-mesh/archive/$pmCommit.zip" -OutFile $pmTemp -UseBasicParsing

Write-Host "Extracting power-mesh..." -ForegroundColor Cyan
$pmDir = "$projectRoot\packages\power-mesh\packages"
$pmExtracted = "power-mesh-$pmCommit"
if (Test-Path "$pmDir\power-mesh") { Remove-Item "$pmDir\power-mesh" -Recurse -Force }
if (Test-Path "$pmDir\$pmExtracted") { Remove-Item "$pmDir\$pmExtracted" -Recurse -Force }
New-Item -ItemType Directory -Force -Path $pmDir | Out-Null
Expand-Archive -Path $pmTemp -DestinationPath $pmDir -Force
Rename-Item -Path "$pmDir\$pmExtracted" -NewName "power-mesh" -Force
Remove-Item $pmTemp -Force

Write-Host "Done! Submodules are ready (exact commits)." -ForegroundColor Green
Write-Host "Run: npm run dev" -ForegroundColor Yellow
