# SMTPサーバーの設定
$smtpServer = "smtpssl.odn.ne.jp"
$smtpPort = 465
$smtpUser = "cax16410"
$smtpPassword = "56mx1r1v"

# メールの内容
$from = "sippo_in_wind@pop21.odn.ne.jp"
$to = "okada.makoto.16@gmail.com"
$subject = "Test Email"
$body = "This is a test email."

# CDO.Message オブジェクトの作成
$email = New-Object -ComObject CDO.Message

# メールの内容設定
$email.From = $from
$email.To = $to
$email.Subject = $subject
$email.TextBody = $body

# SMTPサーバーの設定
$email.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
$email.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = $smtpServer
$email.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = $smtpPort
$email.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
$email.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = $smtpUser
$email.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = $smtpPassword
$email.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = $true
$email.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 60
$email.Configuration.Fields.Update()

# メールの送信
try {
    $email.Send()
    Write-Host "Email sent successfully."
} catch {
    Write-Host "Failed to send email: $($_.Exception.Message)"
}
