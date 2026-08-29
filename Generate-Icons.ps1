Add-Type -AssemblyName System.Drawing

function New-LabeledIcon {
    param(
        [string]$Text,
        [string]$OutputPath,
        [System.Drawing.Color]$BgColor
    )

    $size = 256
    $bmp = New-Object System.Drawing.Bitmap($size, $size)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

    $g.FillEllipse((New-Object System.Drawing.SolidBrush($BgColor)), 0, 0, $size, $size)

    $borderPen = New-Object System.Drawing.Pen([System.Drawing.Color]::White, 4)
    $g.DrawEllipse($borderPen, 2, 2, $size - 5, $size - 5)

    $fontLarge = New-Object System.Drawing.Font("Segoe UI", 52, [System.Drawing.FontStyle]::Bold)
    $fontSmall = New-Object System.Drawing.Font("Segoe UI", 26, [System.Drawing.FontStyle]::Bold)

    $brush = [System.Drawing.Brushes]::White

    $lines = $Text -split "`n"
    if ($lines.Count -eq 1) {
        $measure = $g.MeasureString($lines[0], $fontLarge)
        $x = ($size - $measure.Width) / 2
        $y = ($size - $measure.Height) / 2
        $g.DrawString($lines[0], $fontLarge, $brush, $x, $y)
    } else {
        $totalH = 0
        $measurements = @()
        foreach ($line in $lines) {
            $m = $g.MeasureString($line, $fontSmall)
            $measurements += $m
            $totalH += $m.Height
        }
        $yCur = ($size - $totalH) / 2
        for ($i = 0; $i -lt $lines.Count; $i++) {
            $x = ($size - $measurements[$i].Width) / 2
            $g.DrawString($lines[$i], $fontSmall, $brush, $x, $yCur)
            $yCur += $measurements[$i].Height
        }
    }

    $g.Dispose()

    $hIcon = $bmp.GetHicon()
    $icon = [System.Drawing.Icon]::FromHandle($hIcon)
    $stream = [System.IO.File]::Create($OutputPath)
    $icon.Save($stream)
    $stream.Close()

    [System.Runtime.InteropServices.Marshal]::DestroyIcon($hIcon)
    $bmp.Dispose()
}

$outputDir = Join-Path $PSScriptRoot "icons"
if (!(Test-Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir | Out-Null }

New-LabeledIcon -Text "1080p`nFORTNITE" -OutputPath (Join-Path $outputDir "1080p.ico") -BgColor ([System.Drawing.Color]::FromArgb(30, 100, 200))
New-LabeledIcon -Text "1440p`nFORTNITE" -OutputPath (Join-Path $outputDir "1440p.ico") -BgColor ([System.Drawing.Color]::FromArgb(20, 160, 80))
New-LabeledIcon -Text "1600p`nFORTNITE" -OutputPath (Join-Path $outputDir "1600p.ico") -BgColor ([System.Drawing.Color]::FromArgb(180, 60, 30))

Write-Host "Icons generated in: $outputDir" -ForegroundColor Green
