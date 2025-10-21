#################################################################################################
# URLの指定
$url = "https://tora-ana.jp/detail.php?id=11247" # ここに実際のURLを入力してください

# WebリクエストでURLの内容を取得
$response = Invoke-WebRequest -Uri $url

# 取得した内容から<div class="schedule">...</ul></div>の部分を抽出
$pattern = '<div class="schedule">.*?</ul></div>'
$match = [regex]::Match($response.Content, $pattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)

# 抽出した部分を変数に格納
$scheduleHtml = $match.Value

Write-Host "$scheduleHtml"

#################################################################################################

# HTMLタグを取り除く関数
function Remove-HtmlTags {
    param (
        [string]$html
    )
    # </li>を改行に置換
    $html = $html -replace '</li>', "`n"
    # 正規表現でその他のHTMLタグを削除
    $html = [regex]::Replace($html, '<[^>]+>', '')
    return $html
}


# エンティティの置換を行う関数
function Replace-HtmlEntities {
    param (
        [string]$text
    )
    # 特殊文字のエンティティを元の文字に置換
    $text = $text -replace '&emsp;', '　' # 全角スペース（例：エムスペース）
    return $text
}

# HTMLタグを削除したテキスト
$plainText = Remove-HtmlTags -html $scheduleHtml

# HTMLエンティティを置換
$plainText = Replace-HtmlEntities -text $plainText

# 出力
Write-Output $plainText

#################################################################################################

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

# 結果を表示
Write-Output $newData

#################################################################################################
