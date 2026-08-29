@echo off
title Fortnite 1440p Launcher
setlocal enabledelayedexpansion

set "SCRIPT_DIR=%~dp0"
set "ASSET_DIR=%localappdata%\FortniteLaunchersAssets"
set "RES_EXE=%ASSET_DIR%\SetResolution.exe"
set "GITHUB_BASE=https://raw.githubusercontent.com/orbitthegreatest/Fortnite-Launchers/master"
set "ICON_NAME=1440p.ico"
set "ICON_PATH=%ASSET_DIR%\%ICON_NAME%"
set "SETTINGS_DEST=%localappdata%\FortniteGame\Saved\Config\WindowsClient\GameUserSettings.ini"
set "SETTINGS_LOCAL=%ASSET_DIR%\GameUserSettings_1440p.ini"

if not exist "%ASSET_DIR%" mkdir "%ASSET_DIR%"

if not exist "%ICON_PATH%" (
    set "LOCAL_ICONS=%SCRIPT_DIR%..\icons"
    if exist "!LOCAL_ICONS!\%ICON_NAME%" (
        copy "!LOCAL_ICONS!\%ICON_NAME%" "%ICON_PATH%" >nul 2>&1
    ) else (
        powershell -NoProfile -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%GITHUB_BASE%/icons/%ICON_NAME%' -OutFile '%ICON_PATH%' -UseBasicParsing"
    )
)

if not exist "%RES_EXE%" (
    set "LOCAL_EXE=%SCRIPT_DIR%..\SetResolution.exe"
    if exist "!LOCAL_EXE!" (
        copy "!LOCAL_EXE!" "%RES_EXE%" >nul 2>&1
    ) else (
        powershell -NoProfile -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%GITHUB_BASE%/SetResolution.exe' -OutFile '%RES_EXE%' -UseBasicParsing"
    )
)

if not exist "%SETTINGS_LOCAL%" (
    echo Downloading 1440p GameUserSettings.ini...
    powershell -NoProfile -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%GITHUB_BASE%/GameUserSettings/1440p/GameUserSettings.ini' -OutFile '%SETTINGS_LOCAL%' -UseBasicParsing"
)

echo Applying GameUserSettings.ini...
if not exist "%SETTINGS_LOCAL%" (
    echo [ERROR] GameUserSettings.ini could not be downloaded.
    pause
    exit /b 1
)
if not exist "%localappdata%\FortniteGame\Saved\Config\WindowsClient\" (
    echo [ERROR] Fortnite config folder not found. Launch Fortnite at least once first.
    pause
    exit /b 1
)
if exist "%SETTINGS_DEST%" attrib -r "%SETTINGS_DEST%" >nul 2>&1
copy /y "%SETTINGS_LOCAL%" "%SETTINGS_DEST%" >nul
attrib +r "%SETTINGS_DEST%" >nul 2>&1
echo [OK] GameUserSettings.ini applied.

echo Changing resolution to 2000x1440...
if exist "%RES_EXE%" (
    "%RES_EXE%" 2000 1440
)

echo Launching Fortnite (High Priority)...
start "" /high "com.epicgames.launcher://apps/Fortnite?action=launch&silent=true"

echo Fortnite 1440p launched.
endlocal
