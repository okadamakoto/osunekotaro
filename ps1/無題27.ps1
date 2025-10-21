# クリップボードの内容を取得
$clipboardText = Get-Clipboard

# 正規表現で形式チェック（英字-数字の形式）
if ($clipboardText -match "^([A-Za-z]+)-([0-9]+)$") {
    $prefix = $matches[1]  # 英字部分
    $number = $matches[2]   # 数字部分

    # "-" を "00" に置換して新しいIDを作成
    if ($prefix -eq "START") {
        $newId = "1" + "$prefix" + "00" + "$number"
    } else {
        if ($prefix -eq "MTALL") {
            $newId = "1" + "$prefix" + "00" + "$number"
        } else {
            if ($prefix -eq "SW") {
                $newId = "1" + "$prefix" + "00" + "$number"
            } else {
                if ($prefix -eq "STARS") {
                    $newId = "1" + "$prefix" + "00" + "$number"
                } else {
                    $newId = "$prefix" + "00" + "$number"
                }
            }



#            $newId = "$prefix" + "00" + "$number"
        }
    }

    # 12桁になるまで半角スペースを追加
    $clipboardTextPadded = $clipboardText + (' ' * (12 - $clipboardText.Length))
    $newIdPadded = $newId + (' ' * (12 - $newId.Length))

    # ファイルに追記
    $filePath = "C:\Users\osune\Downloads\titlelist.txt"
    "$clipboardTextPadded`r`n$newIdPadded" | Out-File -Append -Encoding UTF8 $filePath

    # URLを生成
    $url = "https://www.dmm.co.jp/monthly/premium/-/detail/=/cid=$newId/"

    # URLを開く
    Start-Process $url
} else {
    Write-Output "クリップボードの内容が無効な形式です（例: HMN-108）"
    exit
}
