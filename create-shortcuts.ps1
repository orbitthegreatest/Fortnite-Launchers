$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
$sh = New-Object -ComObject WScript.Shell
$gbase = "https://raw.githubusercontent.com/orbitthegreatest/Fortnite-Launchers/master/icons"

$launchers = @(
    @{ Name = "Fortnite 1080p"; Bat = "Fortnite 1080p Launcher.bat"; Icon = "1080p.ico" },
    @{ Name = "Fortnite 1440p"; Bat = "Fortnite 1440p Launcher.bat"; Icon = "1440p.ico" },
    @{ Name = "Fortnite 1600p"; Bat = "Fortnite 1600p Launcher.bat"; Icon = "1600p.ico" }
)

$batDir = Join-Path $dir "..\Custom launchers\Fortnite"
$repoIcons = Join-Path $dir "..\Fortnite-Launchers\icons"

foreach ($l in $launchers) {
    $batPath = Join-Path $batDir $l.Bat
    $icoPath = ""

    $local = Join-Path $batDir "icons\$($l.Icon)"
    $repo = Join-Path $repoIcons $l.Icon
    $asset = "$env:localappdata\FortniteLaunchersAssets\$($l.Icon)"

    if (Test-Path $local) { $icoPath = $local }
    elseif (Test-Path $repo) { $icoPath = $repo }
    elseif (Test-Path $asset) { $icoPath = $asset }
    else {
        Write-Host "Downloading $($l.Icon)..."
        try {
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            $assetDir = "$env:localappdata\FortniteLaunchersAssets"
            if (-not (Test-Path $assetDir)) { New-Item -ItemType Directory -Path $assetDir | Out-Null }
            Invoke-WebRequest -Uri "$gbase/$($l.Icon)" -OutFile $asset -UseBasicParsing
            $icoPath = $asset
        } catch {
            Write-Host "Could not get icon: $($l.Icon)" -ForegroundColor Yellow
        }
    }

    if (-not (Test-Path $batPath)) {
        Write-Host "Missing: $($l.Bat)" -ForegroundColor Yellow
        continue
    }

    $lnkPath = Join-Path $dir "$($l.Name).lnk"
    $lnk = $sh.CreateShortcut($lnkPath)
    $lnk.TargetPath = "cmd.exe"
    $lnk.Arguments = "/c `"$batPath`""
    $lnk.WorkingDirectory = $batDir
    if ($icoPath -and (Test-Path $icoPath)) {
        $lnk.IconLocation = "$icoPath,0"
    }
    $lnk.Description = $l.Name
    $lnk.Save()
    Write-Host "$($l.Name) shortcut created"
}

Write-Host "Done!"
