# メッセージボックスを表示してユーザーに「はい」「いいえ」「キャンセル」を選択させる関数
function Show-YesNoCancelMessageBox {
    [CmdletBinding()]
    param (
        [string]$Message
    )

    Add-Type -AssemblyName System.Windows.Forms
    $result = [System.Windows.Forms.MessageBox]::Show($Message, "確認", "YesNoCancel", "Question")

    if ($result -eq "Yes") {
        return "Yes"
    } elseif ($result -eq "No") {
        return "No"
    } else {
        return "Cancel"
    }
}

$multilineString = "これは
複数行の
文字列です。"

# メッセージボックスを表示してユーザーに選択させる
$choice = Show-YesNoCancelMessageBox -Message "$multilineString を作成しますか？"
# ユーザーの選択に応じて処理を実行
if ($choice) {
    Write-Host "「はい」が選択されました。処理を実行します。"
    # ここに「はい」が選択された場合の処理を記述
    $targetFolder = $targetFolder + "\" + $lastText
} else {
    Write-Host "「いいえ」が選択されました。処理を中止します。"
    # ここに「いいえ」が選択された場合の処理を記述
}

# メッセージボックスを表示してユーザーに選択させる
$choice = Show-YesNoMessageBox -Message "$lastText に作成しますか？"

# ユーザーの選択に応じて処理を実行
if ($choice) {
    Write-Host "「はい」が選択されました。処理を実行します。"
    # ここに「はい」が選択された場合の処理を記述
    $targetFolder = $targetFolder + "\" + $lastText
} else {
    Write-Host "「いいえ」が選択されました。処理を中止します。"
    # ここに「いいえ」が選択された場合の処理を記述
}


