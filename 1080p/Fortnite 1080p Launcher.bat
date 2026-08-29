@echo off
title Fortnite 1080p Launcher
setlocal enabledelayedexpansion

set "SCRIPT_DIR=%~dp0"
set "ASSET_DIR=%localappdata%\FortniteLaunchersAssets"
set "RES_EXE=%ASSET_DIR%\SetResolution.exe"
set "DATA_DIR=C:\Users\tutot\Desktop\Orbit settings\Orbit settings\Data (DO NOT TOUCH THIS)\Fortnite GameUserSettings\1080p"
set "SETTINGS_SRC=%DATA_DIR%\GameUserSettings.ini"
set "SETTINGS_DEST=%localappdata%\FortniteGame\Saved\Config\WindowsClient\GameUserSettings.ini"

echo [1] Starting launcher...
echo [1] SCRIPT_DIR = %SCRIPT_DIR%
echo [1] RES_EXE = %RES_EXE%

echo [2] Checking SetResolution.exe...
if exist "%RES_EXE%" (
    echo [2] Found at %RES_EXE%
) else (
    echo [2] NOT found at ASSET_DIR, checking local...
    if exist "%SCRIPT_DIR%..\SetResolution.exe" (
        set "RES_EXE=%SCRIPT_DIR%..\SetResolution.exe"
        echo [2] Found at !RES_EXE!
    ) else (
        echo [2] NOT FOUND ANYWHERE
        pause
        exit /b 1
    )
)

echo [3] Running SetResolution.exe 1500 1080...
"%RES_EXE%" 1500 1080
echo [3] SetResolution.exe finished with errorlevel %errorlevel%

echo [4] Waiting 3 seconds...
timeout /t 3 /nobreak
echo [4] Done waiting

echo [5] Checking GameUserSettings source...
if exist "%SETTINGS_SRC%" (
    echo [5] Source found: %SETTINGS_SRC%
) else (
    echo [5] Source NOT found: %SETTINGS_SRC%
    pause
    exit /b 1
)

echo [6] Checking Fortnite config folder...
if exist "%localappdata%\FortniteGame\Saved\Config\WindowsClient\" (
    echo [6] Config folder exists
) else (
    echo [6] Config folder NOT found
    pause
    exit /b 1
)

echo [7] Copying GameUserSettings.ini...
if exist "%SETTINGS_DEST%" attrib -r "%SETTINGS_DEST%" >nul 2>&1
copy /y "%SETTINGS_SRC%" "%SETTINGS_DEST%" >nul
echo [7] Copy result: %errorlevel%

echo [8] Setting read-only...
attrib +r "%SETTINGS_DEST%" >nul 2>&1
echo [8] Done

echo [9] Launching Fortnite...
start "" /high "com.epicgames.launcher://apps/Fortnite?action=launch&silent=true"
echo [9] Fortnite launched

echo [10] All done!
pause
endlocal
