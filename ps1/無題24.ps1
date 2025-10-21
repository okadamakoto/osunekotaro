
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