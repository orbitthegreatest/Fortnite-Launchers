@echo off
title Fortnite 1080p Launcher
setlocal enabledelayedexpansion

set "MY_DIR=%~dp0"
set "ASSET_DIR=%localappdata%\FortniteLaunchersAssets"
set "RES_EXE=%ASSET_DIR%\SetResolution.exe"
set "GITHUB_BASE=https://raw.githubusercontent.com/orbitthegreatest/Fortnite-Launchers/master"
set "ICON_PATH=%ASSET_DIR%\1080p.ico"
set "SETTINGS_DEST=%localappdata%\FortniteGame\Saved\Config\WindowsClient\GameUserSettings.ini"
set "SETTINGS_LOCAL=%ASSET_DIR%\GameUserSettings_1080p.ini"
set "REPO_DIR=%MY_DIR%.."

if not exist "%ASSET_DIR%" mkdir "%ASSET_DIR%"

if not exist "%ICON_PATH%" (
    if exist "%REPO_DIR%\icons\1080p.ico" (
        copy "%REPO_DIR%\icons\1080p.ico" "%ICON_PATH%" >nul 2>&1
    ) else (
        powershell -NoProfile -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%GITHUB_BASE%/icons/1080p.ico' -OutFile '%ICON_PATH%' -UseBasicParsing"
    )
)

if exist "%REPO_DIR%\SetResolution.exe" (
    copy /y "%REPO_DIR%\SetResolution.exe" "%RES_EXE%" >nul 2>&1
) else if not exist "%RES_EXE%" (
    powershell -NoProfile -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%GITHUB_BASE%/SetResolution.exe' -OutFile '%RES_EXE%' -UseBasicParsing"
)

if not exist "%SETTINGS_LOCAL%" (
    if exist "%REPO_DIR%\GameUserSettings\1080p\GameUserSettings.ini" (
        copy "%REPO_DIR%\GameUserSettings\1080p\GameUserSettings.ini" "%SETTINGS_LOCAL%" >nul 2>&1
    ) else (
        echo Downloading 1080p GameUserSettings.ini...
        powershell -NoProfile -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%GITHUB_BASE%/GameUserSettings/1080p/GameUserSettings.ini' -OutFile '%SETTINGS_LOCAL%' -UseBasicParsing"
    )
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

echo Changing resolution to 1500x1080 and launching Fortnite...
if exist "%RES_EXE%" (
    "%RES_EXE%" 1500 1080 --launch
) else (
    echo [ERROR] SetResolution.exe not found.
    start "" /high "com.epicgames.launcher://apps/Fortnite?action=launch&silent=true"
)

echo Fortnite 1080p session ended.
endlocal
