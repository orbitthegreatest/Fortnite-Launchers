$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
$sh = New-Object -ComObject WScript.Shell

$bats = @(
    @{ Name = "Fortnite 1080p"; Bat = "Fortnite 1080p Launcher.bat"; Icon = "1080p.ico" },
    @{ Name = "Fortnite 1440p"; Bat = "Fortnite 1440p Launcher.bat"; Icon = "1440p.ico" },
    @{ Name = "Fortnite 1600p"; Bat = "Fortnite 1600p Launcher.bat"; Icon = "1600p.ico" }
)

foreach ($b in $bats) {
    $lnk = $sh.CreateShortcut("$dir\$($b.Name).lnk")
    $lnk.TargetPath = "$dir\$($b.Bat)"
    $lnk.WorkingDirectory = $dir
    $iconFile = "$dir\..\icons\$($b.Icon)"
    if (Test-Path $iconFile) {
        $lnk.IconLocation = "$iconFile,0"
    }
    $lnk.Description = $b.Name
    $lnk.Save()
    Write-Host "Created: $($b.Name).lnk"
}
Write-Host "Done!"
