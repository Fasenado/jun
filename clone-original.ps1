# Скрипт для получения оригинального репозитория next.junni.co.jp без Git
# Запустите вручную в PowerShell

$ErrorActionPreference = "Stop"
$Desktop = [Environment]::GetFolderPath("Desktop")
$TargetDir = Join-Path $Desktop "next.junni.co.jp-original"

Write-Host "=== Клонирование оригинала next.junni.co.jp ===" -ForegroundColor Cyan

# 1. Скачать основной репозиторий
Write-Host "`n1. Скачивание основного репозитория..." -ForegroundColor Yellow
$zipPath = Join-Path $Desktop "next.junni-original.zip"
if (-not (Test-Path $zipPath)) {
    Invoke-WebRequest -Uri "https://github.com/junni-inc/next.junni.co.jp/archive/refs/heads/master.zip" -OutFile $zipPath -UseBasicParsing
} else {
    Write-Host "   ZIP уже существует, пропускаем загрузку" -ForegroundColor Gray
}

# 2. Распаковать
Write-Host "`n2. Распаковка..." -ForegroundColor Yellow
if (Test-Path $TargetDir) { Remove-Item $TargetDir -Recurse -Force }
Expand-Archive -Path $zipPath -DestinationPath $Desktop -Force
Rename-Item (Join-Path $Desktop "next.junni.co.jp-master") $TargetDir -Force

# 3. Подмодули ore-three (точный коммит 2022-11)
$oreCommit = "b7615d8165a9e88b12a4399e24a2226d55931c94"
Write-Host "`n3. Загрузка ore-three ($oreCommit)..." -ForegroundColor Yellow
$oreZip = Join-Path $TargetDir "ore-three-temp.zip"
Invoke-WebRequest -Uri "https://github.com/ukonpower/ore-three/archive/$oreCommit.zip" -OutFile $oreZip -UseBasicParsing
New-Item -ItemType Directory -Force -Path "$TargetDir\packages" | Out-Null
$oreExtracted = "ore-three-$oreCommit"
if (Test-Path "$TargetDir\packages\ore-three") { Remove-Item "$TargetDir\packages\ore-three" -Recurse -Force }
if (Test-Path "$TargetDir\packages\$oreExtracted") { Remove-Item "$TargetDir\packages\$oreExtracted" -Recurse -Force }
Expand-Archive -Path $oreZip -DestinationPath "$TargetDir\packages" -Force
Rename-Item "$TargetDir\packages\$oreExtracted" "ore-three" -Force
Remove-Item $oreZip -Force

# 4. Подмодуль power-mesh (точный коммит 2022-11)
$pmCommit = "778512864b34635de9598a33b95c0d5137dfa659"
Write-Host "`n4. Загрузка power-mesh ($pmCommit)..." -ForegroundColor Yellow
$pmZip = Join-Path $TargetDir "power-mesh-temp.zip"
Invoke-WebRequest -Uri "https://github.com/ukonpower/power-mesh/archive/$pmCommit.zip" -OutFile $pmZip -UseBasicParsing
$pmDir = "$TargetDir\packages\power-mesh\packages"
$pmExtracted = "power-mesh-$pmCommit"
New-Item -ItemType Directory -Force -Path $pmDir | Out-Null
if (Test-Path "$pmDir\power-mesh") { Remove-Item "$pmDir\power-mesh" -Recurse -Force }
if (Test-Path "$pmDir\$pmExtracted") { Remove-Item "$pmDir\$pmExtracted" -Recurse -Force }
Expand-Archive -Path $pmZip -DestinationPath $pmDir -Force
Rename-Item "$pmDir\$pmExtracted" "power-mesh" -Force
Remove-Item $pmZip -Force

# 5. npm install
Write-Host "`n5. Установка зависимостей (npm install)..." -ForegroundColor Yellow
Set-Location $TargetDir
npm install

Write-Host "`n=== Готово! ===" -ForegroundColor Green
Write-Host "Папка: $TargetDir" -ForegroundColor Cyan
Write-Host "Запуск: cd '$TargetDir' ; npm run dev" -ForegroundColor Yellow
Write-Host "`nПримечание: Могут потребоваться фиксы API (isAnimatingVariable и т.д.)" -ForegroundColor Gray
