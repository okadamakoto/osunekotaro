# 元の文字列を変数に格納
$plainText = @"
本　日18:00▼24:00
06月15日（金）―
06月16日（土）―
06月17日（日）―
06月18日（月）―
06月19日（火）―
06月20日（水）―
"@

# データを行ごとに分割
$lines = $plainText -split "`n"

# 2行目の日付を抽出
$secondLine = $lines[1]

# 日付部分を抽出（「06月14日（金）」の「06月14日」部分）
if ($secondLine -match "(\d{2})月(\d{2})日")
{
    $month = [int]$matches[1]
    $day = [int]$matches[2]
}

# 日付をDateTimeオブジェクトに変換
$year = (Get-Date).Year
$dateString = "{0:D4}-{1:D2}-{2:D2}" -f $year, $month, $day
$date = [datetime]::ParseExact($dateString, "yyyy-MM-dd", $null)

# 前日の日付を計算
$previousDate = $date.AddDays(-1)

# 曜日を日本語に変換
$daysOfWeek = @("日", "月", "火", "水", "木", "金", "土")
$dayOfWeekJapanese = $daysOfWeek[$previousDate.DayOfWeek.value__]

# 最初の行から時間部分を抽出
$firstLine = $lines[0]
$timePart = $firstLine -replace "本　日", ""

# 新しい日付文字列を作成
$newDate = $previousDate.ToString("MM月dd日") + "（" + $dayOfWeekJapanese + "）" + $timePart

# 「本　日」の行を新しい日付に置き換え
$lines[0] = $newDate

# 結果を結合
$newData = $lines -join "`n"

# 田中ねね.txtのファイルパス
$filePath = "C:\Users\osune\OneDrive\Documents\田中ねね.txt"

# ファイルの存在を確認
if (Test-Path $filePath) {
    # ファイルの内容を読み込む
    $oldData = Get-Content -Raw -Path $filePath
} else {
    $oldData = ""
}

# 余分な空白や改行を無視してデータを比較
$normalizedNewData = $newData -replace "\s+", "" -replace "\n|\r", ""
$normalizedOldData = $oldData -replace "\s+", "" -replace "\n|\r", ""

if ($normalizedNewData -eq $normalizedOldData) {
    # 同じ場合の出力
    Write-Output "【同じ】"
    Write-Output $newData
} else {
    # 違う場合の出力
    Write-Output "【変更後】"
    Write-Output $newData
    Write-Output ""
    Write-Output "【変更前】"
    Write-Output $oldData

    # 新しいデータをファイルに上書き
    $newData | Out-File -FilePath $filePath -Encoding UTF8
}
