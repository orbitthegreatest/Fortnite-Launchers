@echo off
title Fortnite 1600p Launcher
setlocal enabledelayedexpansion

set "SCRIPT_DIR=%~dp0"
set "ASSET_DIR=%localappdata%\FortniteLaunchersAssets"
set "RES_EXE=%ASSET_DIR%\SetResolution.exe"
set "GITHUB_BASE=https://raw.githubusercontent.com/orbitthegreatest/Fortnite-Launchers/master"
set "ICON_NAME=1600p.ico"
set "ICON_PATH=%ASSET_DIR%\%ICON_NAME%"
set "DATA_DIR=C:\Users\tutot\Desktop\Orbit settings\Orbit settings\Data (DO NOT TOUCH THIS)\Fortnite GameUserSettings\1600p"
set "SETTINGS_SRC=%DATA_DIR%\GameUserSettings.ini"
set "SETTINGS_DEST=%localappdata%\FortniteGame\Saved\Config\WindowsClient\GameUserSettings.ini"

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

echo Applying GameUserSettings.ini...
if not exist "%SETTINGS_SRC%" (
    echo [ERROR] GameUserSettings.ini not found.
    pause
    exit /b 1
)
if not exist "%localappdata%\FortniteGame\Saved\Config\WindowsClient\" (
    echo [ERROR] Fortnite config folder not found.
    pause
    exit /b 1
)
if exist "%SETTINGS_DEST%" attrib -r "%SETTINGS_DEST%" >nul 2>&1
copy /y "%SETTINGS_SRC%" "%SETTINGS_DEST%" >nul
if %errorlevel% equ 0 (
    attrib +r "%SETTINGS_DEST%" >nul 2>&1
    echo [OK] GameUserSettings.ini applied.
) else (
    echo [ERROR] Failed to copy GameUserSettings.ini.
    pause
    exit /b 1
)

echo Launching Fortnite (High Priority)...
start "" /high "com.epicgames.launcher://apps/Fortnite?action=launch&silent=true"

echo Changing resolution to 2293x1440...
if exist "%RES_EXE%" (
    start "" "%RES_EXE%" 2293 1440
)

endlocal
