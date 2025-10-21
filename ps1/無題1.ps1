$MailParam = @{
    SmtpServer = "smtpssl.odn.ne.jp"
    Port = 465
    From = "sippo_in_wind@pop21.odn.ne.jp"
    To = "okada.makoto.16@gmail.com"
    Subject = "<件名>"
    Body = "<本文>"
    Encoding = [System.Text.Encoding]::UTF8
    Credential = Get-Credential -UserName "cax16410" -Password "56mx1r1v"
}
Send-MailMessage @MailParam
