function Add-LogEntry {
    param (
        [string]$filePath,  # ログファイルのパス
        [string]$message    # ログに書き込むメッセージ
    )

    # 現在の日時を取得
    $timeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    # メッセージとタイムスタンプを結合
    $logEntry = "$timeStamp - $message"

    # ファイルに追記
    Add-Content -Path $filePath -Value $logEntry

    # 処理完了メッセージを表示
    Write-Host "ログに追記されました: $logEntry"
}

# 関数の使用例
Add-LogEntry -filePath "C:\Users\osune\OneDrive\Documents\ayulog.txt" -message "1.00"

#$timeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
#Add-Content -Path "C:\path\to\your\file.txt" -Value "処理が完了しました: $timeStamp"

#################################################################################################
# URLの指定
$url = "https://www.cityheaven.net/chiba/A1203/A120302/mken/girlid-40700379/?pcmode=sp"

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

    Write-Output $scheduleText

    # 日付の前で改行を追加（2桁の数字も正しく扱うよう修正）
#    $scheduleText = [regex]::Replace($scheduleText, '(?<=\d{1,2})/(?=\d{1,2}\(\S\))', "`n")

    $scheduleText = [regex]::Replace($scheduleText, '(?<!\d)(?=\d{1,2}/\d{1,2}\(\S\))', "`n")


    # 結果を表示
    Write-Output $scheduleText
} else {
    Write-Host "指定された部分が見つかりませんでした。" -ForegroundColor Red
}

# 田中ねね.txtのファイルパス
$filePath = "C:\Users\osune\OneDrive\Documents\あゆ.txt"

# ファイルの存在を確認
if (Test-Path $filePath) {
    # ファイルの内容を読み込む
    $oldData = Get-Content -Raw -Path $filePath
} else {
    $oldData = ""
}

# 余分な空白や改行を無視してデータを比較
$normalizedNewData = $scheduleText -replace "\s+", "" -replace "\n|\r", ""
$normalizedOldData = $oldData -replace "\s+", "" -replace "\n|\r", ""

if ($normalizedNewData -eq $normalizedOldData) {
    # 同じ場合の出力
    Write-Output "【同じ】"
    Write-Output $scheduleText
} else {
    # 違う場合の出力
#    Write-Output "【変更後】"
#    Write-Output $newData
#    Write-Output ""
#    Write-Output "【変更前】"
#    Write-Output $oldData

# 変更後と変更前の内容を1つの変数に格納して、最後に出力する
# 変更後と変更前の内容を1つの変数に格納して、最後に出力する
$output = @"
【変更後】
$scheduleText

【変更前】
$oldData
"@

Write-Output $output


    # 新しいデータをファイルに上書き
    $scheduleText | Out-File -FilePath $filePath -Encoding UTF8

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
$body = "$output `n "

# CDO.Message オブジェクトの作成
$email = New-Object -ComObject CDO.Message

# メールの内容設定
$email.From = $from
$email.To = $to
$email.Subject = "A $subject"
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
#################################################################################################

}

