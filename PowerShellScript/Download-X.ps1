param(
    [Parameter(Mandatory=$true,Position=0)]
    [string]$HarFile
)

$ErrorActionPreference = "Stop"

# ffmpeg.exe はスクリプトと同じフォルダに置く
$ScriptDir = Split-Path $MyInvocation.MyCommand.Path
$FFmpeg = Join-Path $ScriptDir "ffmpeg.exe"

if (!(Test-Path $FFmpeg)) {
    Write-Host "ffmpeg.exe が見つかりません。"
    exit
}

if (!(Test-Path $HarFile)) {
    Write-Host "HARファイルが見つかりません。"
    exit
}

Write-Host ""
Write-Host "HAR解析中..."

$json = Get-Content $HarFile -Raw | ConvertFrom-Json

$m3u8 = $json.log.entries |
ForEach-Object { $_.request.url } |
Where-Object { $_ -match '\.m3u8' } |
Sort-Object -Unique

if($m3u8.Count -eq 0){
    Write-Host "m3u8 が見つかりません。"
    exit
}

Write-Host ""
Write-Host "検出したプレイリスト"

$m3u8 | ForEach-Object {
    Write-Host " $_"
}

##################################################
# 映像
##################################################

$Videos = @()

foreach($url in $m3u8){

    if($url -match '/pl/avc1/(\d+)x(\d+)/'){

        $Videos += [PSCustomObject]@{

            Width  = [int]$matches[1]

            Height = [int]$matches[2]

            Score  = [int]$matches[1] * [int]$matches[2]

            Url    = $url
        }
    }
}

##################################################
# 音声
##################################################

$Audios = @()

foreach($url in $m3u8){

    if($url -match '/pl/mp4a/(\d+)/'){

        $Audios += [PSCustomObject]@{

            Bitrate=[int]$matches[1]

            Url=$url
        }
    }
}

if($Videos.Count -eq 0){

    Write-Host "映像が見つかりません。"

    exit
}

if($Audios.Count -eq 0){

    Write-Host "音声が見つかりません。"

    exit
}

$BestVideo = $Videos | Sort-Object Score -Descending | Select-Object -First 1

$BestAudio = $Audios | Sort-Object Bitrate -Descending | Select-Object -First 1

Write-Host ""
Write-Host "最高画質"

Write-Host "$($BestVideo.Width)x$($BestVideo.Height)"

Write-Host $BestVideo.Url

Write-Host ""

Write-Host "最高音質"

Write-Host "$($BestAudio.Bitrate)"

Write-Host $BestAudio.Url

##################################################
# 保存ファイル
##################################################

if($BestVideo.Url -match 'amplify_video/(\d+)'){

    $Output = "$($matches[1]).mp4"

}
else{

    $Output = (Get-Date -Format "yyyyMMdd_HHmmss") + ".mp4"

}

Write-Host ""
Write-Host "ダウンロード開始..."
Write-Host ""

& $FFmpeg `
-i $BestVideo.Url `
-i $BestAudio.Url `
-c copy `
-y `
$Output

Write-Host ""
Write-Host "完了"
Write-Host $Output