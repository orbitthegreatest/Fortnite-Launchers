@echo off
title Fortnite 1080p Launcher
setlocal enabledelayedexpansion

set "LOG=%temp%\fortnite_1080p.log"
echo === %date% %time% === > "%LOG%"

set "SCRIPT_DIR=%~dp0"
set "ASSET_DIR=%localappdata%\FortniteLaunchersAssets"
set "RES_EXE=%ASSET_DIR%\SetResolution.exe"
set "GITHUB_BASE=https://raw.githubusercontent.com/orbitthegreatest/Fortnite-Launchers/master"
set "ICON_NAME=1080p.ico"
set "ICON_PATH=%ASSET_DIR%\%ICON_NAME%"
set "DATA_DIR=C:\Users\tutot\Desktop\Orbit settings\Orbit settings\Data (DO NOT TOUCH THIS)\Fortnite GameUserSettings\1080p"
set "SETTINGS_SRC=%DATA_DIR%\GameUserSettings.ini"
set "SETTINGS_DEST=%localappdata%\FortniteGame\Saved\Config\WindowsClient\GameUserSettings.ini"

echo [1] Starting >> "%LOG%"
echo [1] SCRIPT_DIR=%SCRIPT_DIR% >> "%LOG%"
echo [1] ASSET_DIR=%ASSET_DIR% >> "%LOG%"

:: Ensure asset dir exists
if not exist "%ASSET_DIR%" (
    echo [2] Creating ASSET_DIR >> "%LOG%"
    mkdir "%ASSET_DIR%"
)

:: Download icon
echo [3] Checking icon >> "%LOG%"
if not exist "%ICON_PATH%" (
    echo [3] Icon not found, downloading... >> "%LOG%"
    set "LOCAL_ICONS=%SCRIPT_DIR%..\icons"
    if exist "!LOCAL_ICONS!\%ICON_NAME%" (
        copy "!LOCAL_ICONS!\%ICON_NAME%" "%ICON_PATH%" >nul 2>&1
        echo [3] Icon copied from local >> "%LOG%"
    ) else (
        powershell -NoProfile -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%GITHUB_BASE%/icons/%ICON_NAME%' -OutFile '%ICON_PATH%' -UseBasicParsing" 2>>"%LOG%"
        echo [3] Icon downloaded from GitHub >> "%LOG%"
    )
) else (
    echo [3] Icon already exists >> "%LOG%"
)

:: Download SetResolution.exe
echo [4] Checking SetResolution.exe >> "%LOG%"
if not exist "%RES_EXE%" (
    echo [4] Exe not found, downloading... >> "%LOG%"
    set "LOCAL_EXE=%SCRIPT_DIR%..\SetResolution.exe"
    if exist "!LOCAL_EXE!" (
        copy "!LOCAL_EXE!" "%RES_EXE%" >nul 2>&1
        echo [4] Exe copied from local >> "%LOG%"
    ) else (
        powershell -NoProfile -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%GITHUB_BASE%/SetResolution.exe' -OutFile '%RES_EXE%' -UseBasicParsing" 2>>"%LOG%"
        echo [4] Exe downloaded from GitHub >> "%LOG%"
    )
) else (
    echo [4] Exe already exists >> "%LOG%"
)

:: Apply GameUserSettings
echo [5] Applying GameUserSettings.ini >> "%LOG%"
if not exist "%SETTINGS_SRC%" (
    echo [5] ERROR: Source not found: %SETTINGS_SRC% >> "%LOG%"
    echo [ERROR] GameUserSettings.ini not found.
    pause
    exit /b 1
)
if not exist "%localappdata%\FortniteGame\Saved\Config\WindowsClient\" (
    echo [5] ERROR: Fortnite config folder not found >> "%LOG%"
    echo [ERROR] Fortnite config folder not found.
    pause
    exit /b 1
)
if exist "%SETTINGS_DEST%" attrib -r "%SETTINGS_DEST%" >nul 2>&1
copy /y "%SETTINGS_SRC%" "%SETTINGS_DEST%" >nul
echo [5] Copy errorlevel=%errorlevel% >> "%LOG%"
if %errorlevel% equ 0 (
    attrib +r "%SETTINGS_DEST%" >nul 2>&1
    echo [OK] GameUserSettings.ini applied.
) else (
    echo [ERROR] Failed to copy GameUserSettings.ini.
    pause
    exit /b 1
)

:: Launch
echo [6] Checking SetResolution.exe at %RES_EXE% >> "%LOG%"
if exist "%RES_EXE%" (
    echo [6] Exe exists, launching with --launch >> "%LOG%"
    echo [6] Command: start "" "%RES_EXE%" 1500 1080 --launch >> "%LOG%"
    start "" "%RES_EXE%" 1500 1080 --launch
    echo [7] start command returned >> "%LOG%"
) else (
    echo [6] Exe NOT found, launching without resolution change >> "%LOG%"
    start "" /high "com.epicgames.launcher://apps/Fortnite?action=launch&silent=true"
)

echo [8] Done >> "%LOG%"
echo Press any key to exit...
pause >nul
endlocal
