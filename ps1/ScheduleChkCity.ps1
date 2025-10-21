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
    $scheduleText = [regex]::Replace($scheduleText, '(?=\d{1,2}/\d{1,2}\(\S\))', "`n")

    # 結果を表示
    Write-Output $scheduleText
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
$body = "$scheduleText"

# CDO.Message オブジェクトの作成
$email = New-Object -ComObject CDO.Message

# メールの内容設定
$email.From = $from
$email.To = $to
$email.Subject = $subject
$email.TextBody = $body

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
