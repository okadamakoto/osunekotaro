# 元ファイルのパス
$source = "C:\Users\osune\OneDrive\Documents\link5.html"

# 元ファイルが存在するか確認
if (Test-Path $source) {
    # 現在の日時を取得し、指定フォーマットで文字列化
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

    # コピー先ファイルのパスを作成
    $destination = "C:\Users\osune\OneDrive\Documents\link5_$timestamp.html"

    # ファイルをコピー
    Copy-Item -Path $source -Destination $destination

    # コピー完了メッセージを表示
    Write-Host "Copied to $destination"
}
else {
    # エラーメッセージを赤色で表示
    Write-Host "Error: Source file '$source' does not exist." -ForegroundColor Red
}
