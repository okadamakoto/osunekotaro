function Add-LogEntry {
    param (
        [string]$filePath,  # ログファイルのパス
        [string]$message    # ログに書き込むメッセージ
    )

    # 現在の日時を取得
    $timeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    # メッセージとタイムスタンプを結合
    $logEntry = "$timeStamp - $message"

    # ファイルに追記
    Add-Content -Path $filePath -Value $logEntry

    # 処理完了メッセージを表示
    Write-Host "ログに追記されました: $logEntry"
}

# 関数の使用例
Add-LogEntry -filePath "C:\Users\osune\OneDrive\Documents\log.txt" -message "1.00"

#$timeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
#Add-Content -Path "C:\path\to\your\file.txt" -Value "処理が完了しました: $timeStamp"

#################################################################################################
# URLの指定
$url = "https://www.ap-siken.com/kakomon/29_aki/q18.html"

# URLからHTMLソースを取得（UTF-8エンコーディングを指定）
$response = Invoke-WebRequest -Uri $url
$htmlContent = [System.Text.Encoding]::UTF8.GetString($response.RawContentStream.ToArray())


Write-output $htmlContent

exit


