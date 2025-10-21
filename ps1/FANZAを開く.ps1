# クリップボードの内容を取得
$clipboardText = Get-Clipboard

# 正規表現で形式チェック（英字-数字の形式）
if ($clipboardText -match "^([A-Za-z]+)-([0-9]+)$") {
    $prefix, $number = $matches[1], $matches[2]
    
    # 特定のプレフィックスに対して "1" を追加、それ以外はそのまま
#    $newId = if ($prefix -in "START", "MTALL", "SW", "STARS", "SDDE") { "1$prefix" } else { $prefix }
    # 特定のプレフィックスに応じた変換
    if ($prefix -in "START", "MTALL", "SW", "STARS", "STAR", "SDDE") {
        $newId = "1$prefix"
    } elseif ($prefix -eq "VDD") {
        $newId = "24$prefix"
    } else {
        $newId = $prefix
    }

    $newId += "00$number"
    
    # 12桁になるまで半角スペースを追加
    $clipboardTextPadded = $clipboardText.PadRight(12, ' ')
    $newIdPadded = $newId.PadRight(12, ' ')
    
    # ファイルに追記
    $filePath = "C:\Users\osune\Downloads\titlelist.txt"
    "$clipboardTextPadded`r`n$newIdPadded" | Out-File -Append -Encoding UTF8 $filePath
    
    # URLを生成して開く
    Start-Process "https://www.dmm.co.jp/monthly/premium/-/detail/=/cid=$newId/"
} else {
    Write-Output "クリップボードの内容が無効な形式です（例: HMN-108）"
    exit
}
