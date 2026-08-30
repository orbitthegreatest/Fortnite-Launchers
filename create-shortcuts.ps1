param(
    [string]$ShortcutsDir
)

if (-not $ShortcutsDir) {
    $ShortcutsDir = Split-Path -Parent $MyInvocation.MyCommand.Path
}

$sh = New-Object -ComObject WScript.Shell

$resolutions = @(
    @{ Name = "Fortnite 1080p"; Bat = "Fortnite 1080p Launcher.bat"; Icon = "1080p.ico" },
    @{ Name = "Fortnite 1440p"; Bat = "Fortnite 1440p Launcher.bat"; Icon = "1440p.ico" },
    @{ Name = "Fortnite 1600p"; Bat = "Fortnite 1600p Launcher.bat"; Icon = "1600p.ico" }
)

$iconsDir = "$ShortcutsDir\..\icons"

foreach ($r in $resolutions) {
    $batPath = "$ShortcutsDir\$($r.Bat)"
    $icoPath = "$iconsDir\$($r.Icon)"
    $lnkPath = "$ShortcutsDir\$($r.Name).lnk"

    if (-not (Test-Path $batPath)) {
        Write-Host "WARNING: Batch not found: $batPath" -ForegroundColor Yellow
        continue
    }

    $lnk = $sh.CreateShortcut($lnkPath)
    $lnk.TargetPath = "cmd.exe"
    $lnk.Arguments = "/c `"$batPath`""
    $lnk.WorkingDirectory = $ShortcutsDir
    if (Test-Path $icoPath) {
        $lnk.IconLocation = "$icoPath,0"
    }
    $lnk.Description = $r.Name
    $lnk.Save()
    Write-Host "Created: $lnkPath"
}

Write-Host "Done! Shortcuts are portable - works from any location."
