param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$HarFile
)

$ErrorActionPreference = "Stop"

Clear-Host

Write-Host ""
Write-Host "========================================="
Write-Host "        X Downloader for HAR"
Write-Host "========================================="
Write-Host ""

if (!(Test-Path $HarFile))
{
    Write-Host "HARファイルが見つかりません。"
    exit
}

Write-Host "HAR解析中..."
Write-Host ""

$json = Get-Content $HarFile -Raw | ConvertFrom-Json

$m3u8 = @()

foreach($entry in $json.log.entries)
{
    $url = $entry.request.url

    if($url -match "\.m3u8")
    {
        $m3u8 += $url
    }
}

$m3u8 = $m3u8 | Sort-Object -Unique

if($m3u8.Count -eq 0)
{
    Write-Host "m3u8 が見つかりません。"
    exit
}

Write-Host "検出したプレイリスト"

foreach($url in $m3u8)
{
    Write-Host " $url"
}

Write-Host ""

############################################################
# 映像抽出
############################################################

$Videos = @()

foreach($url in $m3u8)
{
    if($url -match "/pl/avc1/(\d+)x(\d+)/")
    {
        $width = [int]$matches[1]
        $height = [int]$matches[2]

        $Videos += [PSCustomObject]@{

            Width = $width

            Height = $height

            Pixels = $width * $height

            Url = $url

        }
    }
}

############################################################
# 音声抽出
############################################################

$Audios = @()

foreach($url in $m3u8)
{
    if($url -match "/pl/mp4a/(\d+)/")
    {
        $Audios += [PSCustomObject]@{

            Bitrate = [int]$matches[1]

            Url = $url

        }
    }
}

if($Videos.Count -eq 0)
{
    Write-Host ""
    Write-Host "映像が見つかりません。"
    exit
}

if($Audios.Count -eq 0)
{
    Write-Host ""
    Write-Host "音声が見つかりません。"
    exit
}

############################################################
# 最高画質
############################################################

$BestVideo =
$Videos |
Sort-Object Pixels -Descending |
Select-Object -First 1

############################################################
# 最高音質
############################################################

$BestAudio =
$Audios |
Sort-Object Bitrate -Descending |
Select-Object -First 1

Write-Host ""
Write-Host "========================================="
Write-Host "最高画質"
Write-Host "========================================="

Write-Host "$($BestVideo.Width)x$($BestVideo.Height)"
Write-Host $BestVideo.Url

Write-Host ""

Write-Host "========================================="
Write-Host "最高音質"
Write-Host "========================================="

Write-Host "$($BestAudio.Bitrate)"
Write-Host $BestAudio.Url

############################################################
# 出力ファイル名
############################################################

if ($BestVideo.Url -match 'amplify_video/(\d+)')
{
    $VideoID = $matches[1]
    $Output = "$VideoID.mp4"
}
else
{
    $Output = (Get-Date -Format "yyyyMMdd_HHmmss") + ".mp4"
}

############################################################
# ffmpeg コマンド生成
############################################################

$Command = @(
    '.\ffmpeg.exe'
    '-i'
    "`"$($BestVideo.Url)`""
    '-i'
    "`"$($BestAudio.Url)`""
    '-c'
    'copy'
    "`"$Output`""
) -join ' '

############################################################
# クリップボードへコピー
############################################################

try
{
    Set-Clipboard -Value $Command
    $ClipboardOK = $true
}
catch
{
    $ClipboardOK = $false
}

############################################################
# 結果表示
############################################################

Write-Host ""
Write-Host "========================================="
Write-Host "出力ファイル"
Write-Host "========================================="
Write-Host $Output

Write-Host ""
Write-Host "========================================="
Write-Host "ffmpeg コマンド"
Write-Host "========================================="
Write-Host ""
Write-Host $Command
Write-Host ""

if ($ClipboardOK)
{
    Write-Host "✓ ffmpegコマンドをクリップボードへコピーしました。" -ForegroundColor Green
    Write-Host ""
    Write-Host "cmd を開いて Ctrl + V → Enter で実行できます。"
}
else
{
    Write-Host "クリップボードへコピーできませんでした。"
}

############################################################
# 保存（任意）
############################################################

$CommandFile = [System.IO.Path]::ChangeExtension($HarFile, ".cmd")
$Command | Out-File -Encoding UTF8 $CommandFile

Write-Host ""
Write-Host "CMDファイルも作成しました。"
Write-Host $CommandFile

Write-Host ""
Write-Host "処理が完了しました。"