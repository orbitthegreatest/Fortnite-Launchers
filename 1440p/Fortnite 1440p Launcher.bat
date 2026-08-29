@echo off
title Fortnite 1440p Launcher
setlocal enabledelayedexpansion

:: ── CONFIG ──────────────────────────────────────────────────────────
set "GITHUB_BASE=https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/Custom%%20launchers/Fortnite/icons"
set "ICON_NAME=1440p.ico"
set "ASSET_DIR=%localappdata%\FortniteLaunchersAssets"
set "ICON_PATH=%ASSET_DIR%\%ICON_NAME%"
set "RESOLUTION=2000x1440"
set "SHORTCUT=C:\Users\tutot\Desktop\Orbit settings\Orbit settings\Windows tweaks\fortnite GameUserSettings\1440p.lnk"
:: ─────────────────────────────────────────────────────────────────────

:: Resolve icon: local folder first, then download from GitHub
set "LOCAL_ICONS=%~dp0..\icons"
if not exist "%ICON_PATH%" (
    if exist "%LOCAL_ICONS%\%ICON_NAME%" (
        if not exist "%ASSET_DIR%" mkdir "%ASSET_DIR%"
        copy "%LOCAL_ICONS%\%ICON_NAME%" "%ICON_PATH%" >nul 2>&1
    ) else (
        if not exist "%ASSET_DIR%" mkdir "%ASSET_DIR%"
        echo Downloading %ICON_NAME% from GitHub...
        powershell -NoProfile -Command ^
            "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%GITHUB_BASE%/%ICON_NAME%' -OutFile '%ICON_PATH%' -UseBasicParsing"
        if not exist "%ICON_PATH%" (
            echo WARNING: Could not download icon. Continuing without custom icon.
        )
    )
)

:: Set display resolution
echo Setting resolution to %RESOLUTION%...
where qres >nul 2>&1
if %errorlevel%==0 (
    qres x=%RESOLUTION:x= y=%
) else (
    powershell -NoProfile -Command ^
        "Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices; public class Display { [DllImport(\"user32.dll\")] public static extern int EnumDisplaySettingsW(string dev, int mode, ref DEVMODE dm); [DllImport(\"user32.dll\")] public static extern int ChangeDisplaySettingsExW(string dev, ref DEVMODE dm, IntPtr hw, uint fl, IntPtr lp); [StructLayout(LayoutKind.Sequential, CharSet=CharSet.Unicode)] public struct DEVMODE { [MarshalAs(UnmanagedType.ByValTStr, SizeConst=32)] public string dmDeviceName; public short dmSpecVersion; public short dmDriverVersion; public short dmSize; public short dmDriverExtra; public int dmFields; public int dmPositionX; public int dmPositionY; public int dmDisplayOrientation; public int dmDisplayFixedOutput; public short dmColor; public short dmDuplex; public short dmYResolution; public short dmTTOption; public short dmCollate; [MarshalAs(UnmanagedType.ByValTStr, SizeConst=32)] public string dmFormName; public short dmLogPixels; public int dmBitsPerPel; public int dmPelsWidth; public int dmPelsHeight; public int dmDisplayFlags; public int dmDisplayFrequency; } }'; $dm = New-Object Display+DEVMODE; $dm.dmSize = [System.Runtime.InteropServices.Marshal]::SizeOf($dm); $dm.dmPelsWidth = 2000; $dm.dmPelsHeight = 1440; $dm.dmFields = 0x00000001 -bor 0x00000002; [Display]::ChangeDisplaySettingsExW($null, [ref]$dm, [IntPtr]::Zero, 0, [IntPtr]::Zero)"
)

:: Run GameUserSettings shortcut
echo Applying 1440p GameUserSettings...
start "" "%SHORTCUT%"
timeout /t 2 /nobreak >nul

:: Launch Fortnite at high priority
echo Launching Fortnite (High Priority)...
start "" /high "com.epicgames.launcher://apps/Fortnite?action=launch&silent=true"

echo.
echo Fortnite 1440p launched successfully.
timeout /t 3 /nobreak >nul
endlocal
