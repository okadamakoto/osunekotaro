# クリップボードからテキストを取得
$clipboardText = Get-Clipboard

# テキストが空でないかチェック
if (-not [string]::IsNullOrWhiteSpace($clipboardText)) {
    # フォルダを作成するパスを設定（適宜変更してください）
    $folderPath = "J:\DataBackUp\Movie\AV\DMM\小花のん"

    # フォルダが存在しない場合、作成する
    if (-not (Test-Path $folderPath)) {
        New-Item -ItemType Directory -Path $folderPath | Out-Null
        Write-Output "フォルダ '$clipboardText' が作成されました。"
    } else {
        Write-Output "フォルダ '$clipboardText' は既に存在します。"
    }
} else {
    Write-Output "クリップボードにテキストが見つかりませんでした。"
}
