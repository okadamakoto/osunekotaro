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

# 次の行の日付を取得する関数
function GetNextLineDate {
    param (
        [string]$text,
        [int]$currentYear
    )
    $lines = $text -split "`n"
    for ($i = 0; $i -lt $lines.Length; $i++) {
        if ($lines[$i] -match "本　日") {
            if ($i + 1 -lt $lines.Length -and $lines[$i + 1] -match '\d{4}/\d{2}/\d{2}') {
                return [datetime]::ParseExact($matches[0], "yyyy/MM/dd", $null)
            }
        }
    }
    return $null
}

# HTMLタグを削除したテキスト
$plainText = Remove-HtmlTags -html $scheduleHtml

# HTMLエンティティを置換
$plainText = Replace-HtmlEntities -text $plainText

# 実行年を取得
$currentYear = (Get-Date).Year

# 次の行の日付を取得
$nextLineDate = GetNextLineDate -text $plainText -currentYear $currentYear

if ($nextLineDate -ne $null) {
    # 前日の日付を計算
    $prevDay = $nextLineDate.AddDays(-1)

    # 曜日を日本語に変換する関数
    function GetJapaneseDayOfWeek {
        param (
            [DayOfWeek]$dayOfWeek
        )
        switch ($dayOfWeek) {
            "Sunday" { return "日" }
            "Monday" { return "月" }
            "Tuesday" { return "火" }
            "Wednesday" { return "水" }
            "Thursday" { return "木" }
            "Friday" { return "金" }
            "Saturday" { return "土" }
        }
    }

    # mm月dd日（ddd）形式に変換
    $formattedDate = "{0:MM}月{0:dd}日（{1}）" -f $prevDay, (GetJapaneseDayOfWeek -dayOfWeek $prevDay.DayOfWeek)

    # 「本　日」を変換した日付に置換
    $plainText = $plainText -replace "本　日", $formattedDate
}

# 出力
Write-Output $plainText
Write-Output $formattedDate
Write-Output $prevDay
