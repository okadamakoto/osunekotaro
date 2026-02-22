# ================================
# 保存先選択
# ================================
$baseFolders = @(
    [PSCustomObject]@{ Name = "twitter"; Path = "L:\DataBackUp\Movie\裏\twitter" },
    [PSCustomObject]@{ Name = "DMM"; Path = "L:\DataBackUp\Movie\AV\DMM" }
)

$selectedBase = $baseFolders | Out-GridView -Title "保存先を選択してください" -OutputMode Single

if (-not $selectedBase) {
    Write-Host "キャンセルされました"
    return
}

$targetFolder = $selectedBase.Path

# ================================
# 女優一覧
# ================================
$names = @(
"澁谷果歩","中山ふみか","水原みその","松本菜奈実","小坂めぐる","奥田咲","松岡ちな",
"稲場るか","小向美奈子","吉川あいみ","田中ねね","つぼみ","葉山さゆり","八木奈々",
"深田結梨","後藤里香","市来美保","吉根ゆりあ","安齋らら","美園和花","立川理恵",
"白石茉莉奈","RION","瀬戸環奈","織田真子","楪カレン","めぐり","星乃夏月",
"福原みな","神木麗","姫咲はな","恋渕ももな","MINAMO"
)

# ================================
# 無効文字除去
# ================================
function Remove-InvalidCharsFromDirectoryName {
    param ([string]$directoryName)
    $invalidChars = [System.IO.Path]::GetInvalidFileNameChars()
    foreach ($char in $invalidChars) {
        $directoryName = $directoryName -replace [regex]::Escape($char), ''
    }
    return $directoryName
}

# ================================
# メッセージボックス
# ================================
function Show-YesNoCancelMessageBox {
    param ([string]$Message)
    Add-Type -AssemblyName System.Windows.Forms
    $result = [System.Windows.Forms.MessageBox]::Show($Message, "確認", "YesNoCancel", "Question")

    if ($result -eq "Yes") { return "Y" }
    elseif ($result -eq "No") { return "N" }
    else { return "Cancel" }
}

# ================================
# クリップボード取得
# ================================
$clipboardText = Get-Clipboard -Format Text
$clipboardText = Remove-InvalidCharsFromDirectoryName $clipboardText

$lastText = ($clipboardText -split ' ')[-1]

# ================================
# ① クリップボード名で作成確認
# ================================
$choice = Show-YesNoCancelMessageBox -Message "$lastText フォルダに作成しますか？"

if ($choice -eq "Y") {
    $targetFolder = $targetFolder + "\" + $lastText
}
elseif ($choice -eq "N") {

    # ================================
    # ② ベースフォルダ確認
    # ================================
    $choice = Show-YesNoCancelMessageBox -Message "$targetFolder フォルダに作成しますか？"

    if ($choice -eq "Y") {
        # そのまま
    }
    elseif ($choice -eq "N") {

        # ================================
        # ③ 女優一覧選択
        # ================================
        $selectedName = $names | Out-GridView -Title "作成先を選択してください" -OutputMode Single

        if (-not $selectedName) {
            Write-Host "キャンセルされました"
            return
        }

        $targetFolder = "$targetFolder\$selectedName"
    }
    else {
        Write-Host "処理をキャンセルしました"
        return
    }
}
else {
    Write-Host "処理をキャンセルしました"
    return
}

# ================================
# フォルダ作成
# ================================
$folderPath = Join-Path -Path $targetFolder -ChildPath $clipboardText

New-Item -Path $folderPath -ItemType Directory -Force | Out-Null

Write-Host ""
Write-Host "✅ フォルダ作成完了"
Write-Host "📁 $folderPath"
Write-Host ""