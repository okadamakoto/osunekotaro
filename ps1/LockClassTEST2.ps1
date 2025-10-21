# LockClassTEST2.ps1
function deblog2 {
    param (
        [string]$msg
    )
    $logPath = "C:\Users\osune\Downloads\deblog2.log"
    $timestamp = Get-Date -Format "yyyy/MM/dd HH:mm:ss"
    "$timestamp $msg" | Out-File -Append -FilePath $logPath
}

function getDateStr {
    return (Get-Date -Format "yyyy/MM/dd")
}

function getTimeStr {
    return (Get-Date -Format "HH:mm:ss")
}

function MailSend {
    param (
        [string]$subject
    )
    # メール送信のための設定
    $smtpServer = "smtpssl.gmail.ne.jp"
    $smtpPort = 465
    $smtpUser = "abcdef"
    $smtpPassword = "fedcba"
    $from = "abcdef@gmail.ne.jp"
    $to = "abcdef@gmail.com,abcdef@gmail.com"
    $bcc = "abcdef@gmail.com"

    $message = New-Object system.net.mail.mailmessage
    $message.from = $from
    $message.To.Add($to)
    $message.Bcc.Add($bcc)
    $message.Subject = $subject
    $message.Body = $subject

    $smtp = New-Object Net.Mail.SmtpClient($smtpServer, $smtpPort)
    $smtp.EnableSsl = $true
    $smtp.Credentials = New-Object System.Net.NetworkCredential($smtpUser, $smtpPassword)
    $smtp.Send($message)
}

function Chk {
    param (
        [string]$dPath
    )
    $global:iStatusB = $global:iStatusA
    $global:iCountA = 0

    function TEST6 {
        param (
            [string]$path
        )
        Get-ChildItem -Path $path -Recurse -File | ForEach-Object {
            if ($_.Name -like "*.crdownload") {
                $global:iCountA++
            }
        }
    }

    TEST6 -path $dPath
    if ($global:iCountA -eq 0) {
        $global:iStatusA = 0
    } else {
        $global:iStatusA = 1
    }
}

# スクリプトの実行
deblog2 "Start"

$global:iStatusB = 0
$global:iStatusA = 0

$global:iCountB = 0
$global:iCountA = 0

$stopPath = "C:\Users\osune\Downloads\stop.txt2"
$STime = getDateStr + " " + getTimeStr
$iCnt = 1

while ($true) {
    Chk -dPath "J:\DataBackUp\Movie\AV\DMM\"

    if ($global:iStatusB -eq 1 -and $global:iStatusA -eq 0) {
        $DLETime = getDateStr + " " + getTimeStr
        deblog2 "ＤＬ終了 $iCnt 回目"
        MailSend "ＤＬ終了 ($DLSTime ～ $DLETime)"
    }

    if ($global:iStatusB -eq 0 -and $global:iStatusA -eq 0) {
        deblog2 "ＤＬファイルが存在しません $iCnt 回目"
    }

    if ($global:iStatusB -eq 1 -and $global:iStatusA -eq 1) {
        deblog2 "ＤＬ中 $global:iCountA 件"
        if ($global:iCountA -lt $global:iCountB) {
            $DLETime = getDateStr + " " + getTimeStr
            MailSend "ＤＬ $global:iCountA 件に変更 ($DLSTime ～ $DLETime)"
        }
        $global:iCountB = $global:iCountA
    }

    if ($global:iStatusB -eq 0 -and $global:iStatusA -eq 1) {
        $DLSTime = getDateStr + " " + getTimeStr
        $iCnt = 1
        deblog2 "ＤＬ開始 $iCnt 回目"
    }

    if (Test-Path $stopPath) {
        $ETime = getDateStr + " " + getTimeStr
        deblog2 "ストップファイルが作成されているので終了します。($STime ～ $ETime)"
        break
    } else {
        $iCnt++
    }

    Start-Sleep -Seconds 10
}
