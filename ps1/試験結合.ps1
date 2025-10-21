# 1. 結合対象の試験IDリスト
#$examIDs = @("05_haru", "06_kaki", "07_aki")  # 自分が使った試験IDをここに
$examIDs = @(
  "07_haru"
, "06_aki"
, "06_haru"
, "05_aki" 
, "05_haru"
, "04_aki" 
, "04_haru"
, "03_aki" 
, "03_haru"
, "02_aki" 
, "02_haru"
, "01_aki" 
, "31_haru"
, "30_aki" 
, "30_haru"
, "29_aki" 
, "29_haru"
, "28_aki" 
, "28_haru"
, "27_aki" 
, "27_haru"
, "26_aki" 
, "26_haru"
, "25_aki" 
, "25_haru"
, "24_aki" 
, "24_haru"
, "23_aki" 
, "23_toku"
, "22_aki" 
, "22_haru"
, "21_aki" 
, "21_haru"
, "20_aki" 
, "20_haru"
, "19_aki" 
, "19_haru"
, "18_aki" 
, "18_haru"
, "17_aki" 
, "17_haru"
, "16_haru"
, "15_haru"
)  # 例として他の試験IDも追加

# 2. 結合先のファイル名
$outputFile = "combined_results.csv"

# 3. 既存の結合ファイルがあれば削除
if (Test-Path $outputFile) {
    Remove-Item $outputFile
}

# 4. 最初のファイルはヘッダー付きでコピー
$firstFile = "$($examIDs[0]).csv"
Copy-Item $firstFile $outputFile

# 5. 2つ目以降のファイルはヘッダー無しで追加
for ($i = 1; $i -lt $examIDs.Count; $i++) {
    $csvFile = "$($examIDs[$i]).csv"
    if (Test-Path $csvFile) {
        Get-Content $csvFile | Select-Object -Skip 1 | Add-Content $outputFile
    }
}

Write-Host "結合完了: $outputFile"
