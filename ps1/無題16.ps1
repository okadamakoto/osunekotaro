# 試験名リスト（例）
#$testList = @("試験1", "試験2", "試験3", "試験4")
$testList = @("04_aki", "04_haru", "03_aki", "03_haru", "02_aki", "01_aki", "31_haru", "30_aki", "30_haru", "29_haru", "28_aki", "28_haru", "27_aki", "27_haru", "26_aki", "26_haru", "25_aki", "25_haru", "24_aki", "24_haru", "23_aki", "23_toku", "22_aki", "22_haru", "21_aki", "21_haru", "20_aki", "20_haru", "19_aki", "19_haru", "18_aki", "18_haru", "17_aki", "17_haru")


# qname.txtファイルのパス
$qnameFilePath = "C:\Users\osune\OneDrive\Documents\qname.txt"

# qname.txtファイルから試験名を読み込む
$qname = Get-Content -Path $qnameFilePath -Raw

Write-Output "【$qname】"

# 改行を削除
$qname = $qname -replace "`r`n|`n|`r", ""

# 結果を表示
Write-Output "【$qname】"


# リスト内の次の試験名に変更
$index = $testList.IndexOf($qname)
Write-Output "$index"
if ($index -ne -1 -and $index -lt $testList.Count - 1) {
    $qname = $testList[$index + 1]
} else {
    Write-Output "一致する試験名がリストにないか、最後の試験名です。変更はありません。"
}


Write-Output "【$qname】"

# 新しい試験名でqname.txtファイルを上書き
#$qname | Set-Content -Path $qnameFilePath
