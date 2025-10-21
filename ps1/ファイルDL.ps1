

# URLと対応するファイル名のリストを作成
$downloads = @(
#    @{ Url = "https://cdn77-vid-mp4.xvideos-cdn.com/Z1EmpBw8U6DTvkyr8hHSVw==,1746347429/videos/mp4/3/3/5/xvideos.com_335e5840a01906311d7acc1e742c2257.mp4?ui=MTA2LjczLjE1OC4yMjQtLS92aWRlby5rb2tma2lrZjFmYy9fMg=="; FileName = "真心を込めて奉仕するスライム乳 2.mp4" },
#    @{ Url = "https://video.twimg.com/amplify_video/1918510551854137344/vid/avc1/854x480/qyd2W5UHBTi1q54v.mp4?tag=16"; FileName = "qyd2W5UHBTi1q54v.mp4" }
#    @{ Url = "https://cdn77-vid-mp4.xvideos-cdn.com/JIXz7JffkdfmZ4QBtFHEDA==,1746353932/videos/mp4/2/e/1/xvideos.com_2e1c544fea1d4aa315e3739a44213fdc-1.mp4?ui=MTA2LjczLjE1OC4yMjQtLS92aWRlby5obGZpdGs5YTYxL2tvbXVrYWlfbWluYQ=="; FileName = "komukai_minako_TYOHATU.mp4" }
#    @{ Url = "https://video.twimg.com/amplify_video/1786688720793661440/vid/avc1/1280x720/vpGjyj9CuCiX4rka.mp4?tag=14"; FileName = "vpGjyj9CuCiX4rka.mp4" }
#    @{ Url = "https://cdn77-vid-mp4.xvideos-cdn.com/O01zH0FJ3NA8m0he-FbQUw==,1746357607/videos/mp4/5/f/4/xvideos.com_5f44506bfe0cfacbd3948a7d104d7d8c-1.mp4?ui=MTA2LjczLjE1OC4yMjQtLS92aWRlby5tZmNkYXZjYjMzL18="; FileName = "ストッキング姿の小向真奈美がバイブで犯される.mp4" }
#    @{ Url = "https://video.twimg.com/amplify_video/1918430468216897540/vid/avc1/854x480/cRijUNYoNsJabjMj.mp4?tag=16"; FileName = "cRijUNYoNsJabjMj.mp4" }
#    @{ Url = "https://cdn77-vid-mp4.xvideos-cdn.com/HIBt9g_VVpu502xt005cqw==,1746358086/videos/mp4/7/2/5/xvideos.com_7256b19ae446e940c3c0d4453c9f37e6.mp4?ui=MTA2LjczLjE1OC4yMjQtLS92aWRlby5pZGtlaGJoYjhiNi9fMQ=="; FileName = "花弁と大蛇_小向美奈子_1.mp4" }
    @{ Url = "https://github.com/sakura-editor/sakura/releases/download/v2.4.2/sakura-tag-v2.4.2-build4203-a3e63915b-Win32-Release-Installer.zip"; FileName = "sakura-tag-v2.4.2-build4203-a3e63915b-Win32-Release-Installer.zip" }


)


# 現在日時を指定フォーマットで取得
$StartDateTime = Get-Date


# 保存先ディレクトリを指定
$saveDirectory = "K:\DataBackUp\Movie\xvideos\小向美奈子\"
#$saveDirectory = "K:\DataBackUp\Movie\twitter\裏\マドンナALL専属バスツアー2025 ハーレムを掴み取った男たちが極上の美女を独占！！酒池肉林のお祭りはまだまだ続く！！夢の大共演＆大乱交FESTIVAL！！後編\"
$saveDirectory = "C:\Users\osune\Downloads"


# 各URLについてダウンロードを実行
foreach ($download in $downloads) {
    $url = $download.Url
    $fileName = $download.FileName

    # 保存先ファイルパスを作成
    $outputPath = Join-Path -Path $saveDirectory -ChildPath $fileName

    # ダウンロード実行
    Invoke-WebRequest -Uri $url -OutFile $outputPath

    Write-Host "ダウンロード完了: $fileName"
}



#################################################################################################

# 現在日時を指定フォーマットで取得
$currentDateTime = Get-Date -Format "yyyy/MM/dd HH:mm:ss"

# 現在日時を指定フォーマットで取得
$EndDateTime = Get-Date

# 経過時間を計算
$Elapsed = $EndDateTime - $StartDateTime
Write-Host "処理時間: $($Elapsed.ToString())"

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
$body = "$StartDateTime ～ $EndDateTime `n 処理時間: $($Elapsed.ToString()) `n $saveDirectory `n "

# CDO.Message オブジェクトの作成
$email = New-Object -ComObject CDO.Message

# メールの内容設定
$email.From = $from
$email.To = $to
$email.Subject = "DL完了 $fileName"
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

