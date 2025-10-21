# メッセージボックスを表示してユーザーに「はい」「いいえ」「キャンセル」を選択させる関数
function Show-YesNoCancelMessageBox {
    [CmdletBinding()]
    param (
        [string]$Message
    )

    Add-Type -AssemblyName System.Windows.Forms
    $result = [System.Windows.Forms.MessageBox]::Show($Message, "確認", "YesNoCancel", "Question")

    if ($result -eq "Yes") {
        return "Y"
    } elseif ($result -eq "No") {
        return "N"
    } else {
        return "Cancel"
    }
}



# メッセージボックスを表示してユーザーに「はい」か「いいえ」を選択させる関数
function Show-YesNoMessageBox {
    [CmdletBinding()]
    param (
        [string]$Message
    )

    Add-Type -AssemblyName System.Windows.Forms
    $result = [System.Windows.Forms.MessageBox]::Show($Message, "確認", "YesNo", "Question")

    if ($result -eq "Yes") {
        return $true
    } else {
        return $false
    }
}

# メインのスクリプト

# クリップボードからテキストを取得
$clipboardText = Get-Clipboard -Format Text

# 作成するフォルダのパスを指定
$targetFolder = "J:\DataBackUp\Movie\AV\DMM"

$targetName = "\小坂めぐる"

#$targetFolder ="$targetFolder$targetName"
#$targetFolder ="$targetFolder$targetName"

# ②: テキストを半角スペースで分割し、最後のテキストを取得
$lastText = ($clipboardText -split ' ')[-1]

# メッセージボックスを表示してユーザーに選択させる
#$choice = Show-YesNoMessageBox -Message "$lastText に作成しますか？"
#
## ユーザーの選択に応じて処理を実行
#if ($choice) {
#    Write-Host "「はい」が選択されました。処理を実行します。"
#    # ここに「はい」が選択された場合の処理を記述
#    $targetFolder = $targetFolder + "\" + $lastText
#} else {
#    Write-Host "「いいえ」が選択されました。処理を中止します。"
#    # ここに「いいえ」が選択された場合の処理を記述
#}

$choice = Show-YesNoCancelMessageBox -Message "$lastText フォルダに作成しますか？"

if ($choice -eq "Y") {
    Write-Host "「はい」が選択されました。処理を実行します。"
    $targetFolder = $targetFolder + "\" + $lastText
} elseif ($choice -eq "N") {
    Write-Host "「いいえ」が選択されました。 $targetFolder フォルダに作成します。"
} else {
    Write-Host "処理をキャンセルしました。"
    return
}



# 新しいフォルダを作成
$folderPath = Join-Path -Path $targetFolder -ChildPath $clipboardText
New-Item -Path $folderPath -ItemType Directory -Force

#成功メッセージを表示
Write-Host　"フォルダ '$clipboardText' が '$targetFolder に作成されました。"


