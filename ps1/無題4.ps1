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

# メッセージボックスを表示してユーザーに選択させる
$choice = Show-YesNoMessageBox -Message "この処理を実行しますか？"

# ユーザーの選択に応じて処理を実行
if ($choice) {
    Write-Host "「はい」が選択されました。処理を実行します。"
    # ここに「はい」が選択された場合の処理を記述
} else {
    Write-Host "「いいえ」が選択されました。処理を中止します。"
    # ここに「いいえ」が選択された場合の処理を記述
}
