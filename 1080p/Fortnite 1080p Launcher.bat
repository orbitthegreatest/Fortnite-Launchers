@echo off
title Fortnite 1080p Launcher
setlocal enabledelayedexpansion

:: ── CONFIG ──────────────────────────────────────────────────────────
set "GITHUB_BASE=https://raw.githubusercontent.com/orbitthegreatest/Fortnite-Launchers/master"
set "ICON_NAME=1080p.ico"
set "ASSET_DIR=%localappdata%\FortniteLaunchersAssets"
set "ICON_PATH=%ASSET_DIR%\%ICON_NAME%"
set "RES_W=1500"
set "RES_H=1080"
set "DATA_DIR=C:\Users\tutot\Desktop\Orbit settings\Orbit settings\Data (DO NOT TOUCH THIS)\Fortnite GameUserSettings\1080p"
set "SETTINGS_SRC=%DATA_DIR%\GameUserSettings.ini"
set "SETTINGS_DEST=%localappdata%\FortniteGame\Saved\Config\WindowsClient\GameUserSettings.ini"
set "SCRIPT_DIR=%~dp0"
:: ─────────────────────────────────────────────────────────────────────

:: ── DOWNLOAD ASSETS ON FIRST LAUNCH ─────────────────────────────────
if not exist "%ASSET_DIR%" mkdir "%ASSET_DIR%"

if not exist "%ICON_PATH%" (
    set "LOCAL_ICONS=%SCRIPT_DIR%..\icons"
    if exist "!LOCAL_ICONS!\%ICON_NAME%" (
        copy "!LOCAL_ICONS!\%ICON_NAME%" "%ICON_PATH%" >nul 2>&1
    ) else (
        echo Downloading %ICON_NAME% from GitHub...
        powershell -NoProfile -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%GITHUB_BASE%/icons/%ICON_NAME%' -OutFile '%ICON_PATH%' -UseBasicParsing"
    )
)

if not exist "%ASSET_DIR%\SetResolution.exe" (
    set "LOCAL_EXE=%SCRIPT_DIR%..\SetResolution.exe"
    if exist "!LOCAL_EXE!" (
        copy "!LOCAL_EXE!" "%ASSET_DIR%\SetResolution.exe" >nul 2>&1
    ) else (
        echo Downloading SetResolution.exe from GitHub...
        powershell -NoProfile -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%GITHUB_BASE%/SetResolution.exe' -OutFile '%ASSET_DIR%\SetResolution.exe' -UseBasicParsing"
    )
)
:: ─────────────────────────────────────────────────────────────────────

:: ── CHANGE DESKTOP RESOLUTION ───────────────────────────────────────
echo Setting desktop resolution to %RES_W%x%RES_H%...
if exist "%ASSET_DIR%\SetResolution.exe" (
    "%ASSET_DIR%\SetResolution.exe" %RES_W% %RES_H%
) else if exist "%SCRIPT_DIR%..\SetResolution.exe" (
    "%SCRIPT_DIR%..\SetResolution.exe" %RES_W% %RES_H%
) else (
    echo [ERROR] SetResolution.exe not found. Cannot change resolution.
)
:: ─────────────────────────────────────────────────────────────────────

:: ── APPLY GAMEUSERSETTINGS ──────────────────────────────────────────
echo Applying GameUserSettings.ini...
if not exist "%SETTINGS_SRC%" (
    echo [ERROR] GameUserSettings.ini not found in: %DATA_DIR%
    pause
    exit /b 1
)
if not exist "%localappdata%\FortniteGame\Saved\Config\WindowsClient\" (
    echo [ERROR] Fortnite config folder not found. Launch Fortnite at least once first.
    pause
    exit /b 1
)
if exist "%SETTINGS_DEST%" attrib -r "%SETTINGS_DEST%" >nul 2>&1
copy /y "%SETTINGS_SRC%" "%SETTINGS_DEST%" >nul
if %errorlevel% equ 0 (
    attrib +r "%SETTINGS_DEST%" >nul 2>&1
    echo [SUCCESS] GameUserSettings.ini applied and set to read-only.
) else (
    echo [ERROR] Failed to copy GameUserSettings.ini. Close Fortnite/Epic Launcher and try again.
    pause
    exit /b 1
)
:: ─────────────────────────────────────────────────────────────────────

:: ── LAUNCH FORTNITE ─────────────────────────────────────────────────
echo Launching Fortnite (High Priority)...
start "" /high "com.epicgames.launcher://apps/Fortnite?action=launch&silent=true"

echo.
echo Fortnite 1080p launched successfully.
timeout /t 3 /nobreak >nul
endlocal
