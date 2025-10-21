# 元の文字列
$data = @"
本　日18:00▼24:00
03月01日（金）―
06月15日（土）18:00▼24:00
06月16日（日）―
06月17日（月）―
06月18日（火）―
06月19日（水）―
"@

# データを行ごとに分割
$lines = $data -split "`n"

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

# 結果を表示
Write-Output $newData
