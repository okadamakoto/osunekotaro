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


# メッセージボックスを表示してユーザーに選択させる
#$choice = Show-YesNoCancelMessageBox -Message " を作成しますか？"

$choice = Show-YesNoCancelMessageBox -Message "続行しますか？"
if ($choice -eq "Y") {
    Write-Host "処理を続行します。"
} elseif ($choice -eq "N") {
    Write-Host "処理を中止します。"
} else {
    Write-Host "処理をキャンセルしました。"
    return
}

Write-Host "処理①を実行します。"
