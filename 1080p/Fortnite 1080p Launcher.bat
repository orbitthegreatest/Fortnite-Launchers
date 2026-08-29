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

echo A >> "%LOG%"
if not exist "%ASSET_DIR%" mkdir "%ASSET_DIR%"
echo B >> "%LOG%"
if not exist "%ICON_PATH%" (
    set "LOCAL_ICONS=%SCRIPT_DIR%..\icons"
    if exist "!LOCAL_ICONS!\%ICON_NAME%" (
        copy "!LOCAL_ICONS!\%ICON_NAME%" "%ICON_PATH%" >nul 2>&1
    ) else (
        powershell -NoProfile -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%GITHUB_BASE%/icons/%ICON_NAME%' -OutFile '%ICON_PATH%' -UseBasicParsing"
    )
)
echo C >> "%LOG%"
if not exist "%RES_EXE%" (
    set "LOCAL_EXE=%SCRIPT_DIR%..\SetResolution.exe"
    if exist "!LOCAL_EXE!" (
        copy "!LOCAL_EXE!" "%RES_EXE%" >nul 2>&1
    ) else (
        powershell -NoProfile -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%GITHUB_BASE%/SetResolution.exe' -OutFile '%RES_EXE%' -UseBasicParsing"
    )
)
echo D >> "%LOG%"
echo E src=%SETTINGS_SRC% >> "%LOG%"
echo F dest=%SETTINGS_DEST% >> "%LOG%"
echo G exist_src= >> "%LOG%"
if exist "%SETTINGS_SRC%" (echo YES >> "%LOG%") else (echo NO >> "%LOG%")
echo H exist_dest_folder= >> "%LOG%"
if exist "%localappdata%\FortniteGame\Saved\Config\WindowsClient\" (echo YES >> "%LOG%") else (echo NO >> "%LOG%")
echo I removing_readonly >> "%LOG%"
if exist "%SETTINGS_DEST%" attrib -r "%SETTINGS_DEST%" >nul 2>&1
echo J copying >> "%LOG%"
copy /y "%SETTINGS_SRC%" "%SETTINGS_DEST%" >nul
echo K copy_result=%errorlevel% >> "%LOG%"
echo L setting_readonly >> "%LOG%"
attrib +r "%SETTINGS_DEST%" >nul 2>&1
echo M done_copying >> "%LOG%"
echo N checking_exe >> "%LOG%"
if exist "%RES_EXE%" (
    echo O exe_found launching >> "%LOG%"
    start "" "%RES_EXE%" 1500 1080 --launch
    echo P launch_sent >> "%LOG%"
) else (
    echo O exe_not_found >> "%LOG%"
    start "" /high "com.epicgames.launcher://apps/Fortnite?action=launch&silent=true"
    echo P fallback_launch_sent >> "%LOG%"
)
echo Q very_end >> "%LOG%"
pause
endlocal
