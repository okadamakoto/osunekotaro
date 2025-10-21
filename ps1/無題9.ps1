$targetName = "\澁谷果歩"
$targetName = "\中山ふみか"
$targetName = "\水原みその"
$targetName = "\松本菜奈実"
$targetName = "\小坂めぐる"
$targetName = "\奥田咲"
$targetName = "\松岡ちな"
$targetName = "\稲場るか"
$targetName = "\小向美奈子"
$targetName = "\小坂めぐる"
$targetName = "\吉川あいみ"
$targetName = "\田中ねね"

#吉川あいみ エスワン8時間コンプリートBEST

$targetName = "\田中ねね"


# 無効な文字を取り除く関数
function Remove-InvalidCharsFromDirectoryName {
    param (
        [string]$directoryName
    )
    
    # 使用できない文字を取得
    $invalidChars = [System.IO.Path]::GetInvalidFileNameChars()

    # 無効な文字を取り除く
    foreach ($char in $invalidChars) {
        $directoryName = $directoryName -replace [regex]::Escape($char), ''
    }

    # 無効な文字が取り除かれたディレクトリ名を返す
    return $directoryName
}

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
$targetFolder = "K:\DataBackUp\Movie\AV\DMM"


#$targetFolder ="$targetFolder$targetName"
#$targetFolder ="$targetFolder$targetName"

# ②: テキストを半角スペースで分割し、最後のテキストを取得
$lastText = ($clipboardText -split ' ')[-1]


$choice = Show-YesNoCancelMessageBox -Message "$lastText フォルダに作成しますか？"

if ($choice -eq "Y") {
    Write-Host "「はい」が選択されました。処理を実行します。"
    $targetFolder = $targetFolder + "\" + $lastText
} elseif ($choice -eq "N") {
    Write-Host "「いいえ」が選択されました。 $targetFolder フォルダに作成します。"
    $choice = Show-YesNoCancelMessageBox -Message "「いいえ」が選択されました。 $targetFolder フォルダに作成しますか？"
    if ($choice -eq "Y") {
    } elseif ($choice -eq "N") {
#        $targetName = "\小坂めぐる"
        $targetFolder ="$targetFolder$targetName"
        $choice = Show-YesNoCancelMessageBox -Message "「いいえ」が選択されました。 $targetFolder フォルダに作成しますか？"
        if ($choice -eq "Y") {
            Write-Host " $targetFolder フォルダに作成します"

        } elseif ($choice -eq "N"){
            Write-Host "処理をキャンセルしました。(0)"
            return
        } else {
            Write-Host "処理をキャンセルしました。(1)"
            return
        }
    } else {
        Write-Host "処理をキャンセルしました。(2)"
        return
    }
} else {
    Write-Host "処理をキャンセルしました。(3)"
    return
}



# 新しいフォルダを作成
$folderPath = Join-Path -Path $targetFolder -ChildPath $clipboardText
New-Item -Path $folderPath -ItemType Directory -Force

#成功メッセージを表示
Write-Host　"フォルダ '$clipboardText' が '$targetFolder に作成されました。"


