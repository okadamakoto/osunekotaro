# クリップボードからテキストを取得
$clipboardText = Get-Clipboard -Format Text

# 作成するフォルダのパスを指定
$targetFolder = "J:\DataBackUp\Movie\AV\DMM\後藤里香"

# 新しいフォルダを作成
$folderPath = Join-Path -Path $targetFolder -ChildPath $clipboardText
New-Item -Path $folderPath -ItemType Directory -Force

#成功メッセージを表示
Write-Host　"フォルダ '$clipboardText' が '$targetFolder に作成されました。"
