# 必要なモジュールをインポート
#Import-Module -Name "MailKit"

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


# 抽出したHTMLコンテンツ
$htmlContent = @"
<div class="schedule">
<ul>
<li><p>本&emsp;日</p><p>―</p></li>
<li><p>05月27日（月）</p><p>―</p></li>
<li><p>05月28日（火）</p><p>―</p></li>
<li><p>05月29日（水）</p><p>―</p></li>
<li><p>05月30日（木）</p><p>―</p></li>
<li><p>05月31日（金）</p><p>―</p></li>
<li><p>06月01日（土）</p><p>―</p></li>
</ul></div>
"@


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

#################################################################################################
#################################################################################################
# 変数の設定
$url = "https://www.cityheaven.net/chiba/A1203/A120302/mken/girlid-40700379/?pcmode=sp"
#$url = "https://www.cityheaven.net/tokyo/A1303/A130301/toranoana/girlid-35851109/?pcmode=sp"


# URLからHTMLソースを取得（UTF-8エンコーディングを指定）
$response = Invoke-WebRequest -Uri $url
$htmlContent = [System.Text.Encoding]::UTF8.GetString($response.RawContentStream.ToArray())

# 必要な部分を抽出する正規表現
$regex = [regex]::new('<div class="drawer_popup drawer_syukin">(.*?)<div class="gh_bg_front_syukin dp_close_syukin">', [System.Text.RegularExpressions.RegexOptions]::Singleline)
$match = $regex.Match($htmlContent)

if ($match.Success) {
    $scheduleHtml = $match.Groups[1].Value

    # HTMLタグと&nbsp;を取り除く
    $scheduleText = [regex]::Replace($scheduleHtml, '<.*?>|&nbsp;', '')

    # 余分なスペースと改行を取り除く
    $scheduleText = $scheduleText -replace '\s+', ' ' -replace '\r?\n', ' '

    # 日付の前で改行を追加
#    $scheduleText = [regex]::Replace($scheduleText, '(?=\d{1,2}/\d{1,2}\(\S\))', "`n")
    $scheduleText = [regex]::Replace($scheduleText, '(?<!\d)(?=\d{1,2}/\d{1,2}\(\S\))', "`n")

    # 結果を表示
    Write-Output $scheduleText
} else {
    Write-Host "指定された部分が見つかりませんでした。" -ForegroundColor Red
}
#################################################################################################
# 変数の設定
#$url = "https://www.cityheaven.net/chiba/A1203/A120302/mken/girlid-40700379/?pcmode=sp"
$url = "https://www.cityheaven.net/tokyo/A1303/A130301/toranoana/girlid-35851109/?pcmode=sp"


# URLからHTMLソースを取得（UTF-8エンコーディングを指定）
$response = Invoke-WebRequest -Uri $url
$htmlContent = [System.Text.Encoding]::UTF8.GetString($response.RawContentStream.ToArray())

# 必要な部分を抽出する正規表現
$regex = [regex]::new('<div class="drawer_popup drawer_syukin">(.*?)<div class="gh_bg_front_syukin dp_close_syukin">', [System.Text.RegularExpressions.RegexOptions]::Singleline)
$match = $regex.Match($htmlContent)

if ($match.Success) {
    $scheduleHtml = $match.Groups[1].Value

    # HTMLタグと&nbsp;を取り除く
    $scheduleText2 = [regex]::Replace($scheduleHtml, '<.*?>|&nbsp;', '')

    # 余分なスペースと改行を取り除く
    $scheduleText2 = $scheduleText2 -replace '\s+', ' ' -replace '\r?\n', ' '

    # 日付の前で改行を追加
#    $scheduleText2 = [regex]::Replace($scheduleText2, '(?=\d{1,2}/\d{1,2}\(\S\))', "`n")
    $scheduleText2 = [regex]::Replace($scheduleText2, '(?<!\d)(?=\d{1,2}/\d{1,2}\(\S\))', "`n")


    # 結果を表示
    Write-Output $scheduleText2
} else {
    Write-Host "指定された部分が見つかりませんでした。" -ForegroundColor Red
}
#################################################################################################

# 現在日時を指定フォーマットで取得
$currentDateTime = Get-Date -Format "yyyy/MM/dd HH:mm:ss"

# SMTPサーバーの設定
$smtpServer = "smtpssl.odn.ne.jp"
$smtpPort = 465
$smtpUser = "cax16410"
$smtpPassword = "56mx1r1v"

# メールの内容
$from = "sippo_in_wind@pop21.odn.ne.jp"
$to = "okada.makoto.16@gmail.com"
$subject = "$currentDateTime"
#$body = "$plainText `n $scheduleText `n $scheduleText2"
$body = "$newData `n $scheduleText `n $scheduleText2"



# CDO.Message オブジェクトの作成
$email = New-Object -ComObject CDO.Message

# メールの内容設定
$email.From = $from
$email.To = $to
$email.Subject = $subject
$email.TextBody = $body

# SMTPサーバーの設定
#$email.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
#$email.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = $smtpServer
#$email.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = $smtpPort
#$email.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
#$email.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = $smtpUser
#$email.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = $smtpPassword
#$email.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = $true
#$email.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 60
#$email.Configuration.Fields.Update()


# 共通部分のURIを変数に格納
$schemaURI = "http://schemas.microsoft.com/cdo/configuration/"

# SMTPサーバーの設定
$smtpSettings = @{
    "sendusing" = 2
    "smtpserver" = $smtpServer
    "smtpserverport" = $smtpPort
    "smtpauthenticate" = 1
    "sendusername" = $smtpUser
    "sendpassword" = $smtpPassword
    "smtpusessl" = $true
    "smtpconnectiontimeout" = 60
}

foreach ($key in $smtpSettings.Keys) {
    $email.Configuration.Fields.Item($schemaURI + $key) = $smtpSettings[$key]
}
$email.Configuration.Fields.Update()

# メールの送信
try {
    $email.Send()
    Write-Host "Email sent successfully."
} catch {
    Write-Host "Failed to send email: $($_.Exception.Message)"
}
#################################################################################################
