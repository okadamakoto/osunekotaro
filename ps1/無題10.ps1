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

# 関数の使用
Add-LogEntry -filePath "C:\Users\osune\OneDrive\Documents\ayulogtest.txt" -message "1.00"

#################################################################################################
# URLの指定
$url = "https://www.cityheaven.net/chiba/A1203/A120302/mken/girlid-40700379/?pcmode=sp"

# URLからHTMLソースを取得（UTF-8エンコーディングを指定）
$response = Invoke-WebRequest -Uri $url
$htmlContent = [System.Text.Encoding]::UTF8.GetString($response.RawContentStream.ToArray())


# 必要な部分を抽出する正規表現
$regex = [regex]::new('<div class="drawer_popup drawer_syukin">(.*?)<div class="gh_bg_front_syukin dp_close_syukin">', [System.Text.RegularExpressions.RegexOptions]::Singleline)
$match = $regex.Match($htmlContent)

if ($match.Success) {
    $scheduleHtml = $match.Groups[1].Value

    # HTMLタグと&nbsp;を取り除く
    $scheduleText = [regex]::Replace($scheduleHtml, '<.*?>|&nbsp;', '')

    # 余分なスペースと改行を取り除く
    $scheduleText = $scheduleText -replace '\s+', ' ' -replace '\r?\n', ' '

    Write-Output $scheduleText

    # 日付の前で改行を追加（2桁の数字も正しく扱うよう修正）
    $scheduleText = [regex]::Replace($scheduleText, '(?<!\d)(?=\d{1,2}/\d{1,2}\(\S\))', "`n")

    # 結果を表示
    Write-Output $scheduleText
} else {
    Write-Host "指定された部分が見つかりませんでした。" -ForegroundColor Red
}

# txtのファイルパス
$filePath = "C:\Users\osune\OneDrive\Documents\あゆtest.txt"

# ファイルの存在を確認
if (Test-Path $filePath) {
    # ファイルの内容を読み込む
    $oldData = Get-Content -Raw -Path $filePath
} else {
    $oldData = ""
}

# 余分な空白や改行を無視してデータを比較
$normalizedNewData = $scheduleText -replace "\s+", "" -replace "\n|\r", ""
$normalizedOldData = $oldData -replace "\s+", "" -replace "\n|\r", ""

if ($normalizedNewData -eq $normalizedOldData) {
    # 同じ場合の出力
    Write-Output "【同じ】"
    Write-Output $scheduleText
} else {
    # 変更後と変更前の内容を1つの変数に格納して、最後に出力する
$output = @"
【変更後】
$scheduleText

【変更前】
$oldData
"@


    $beforeLines = $oldData -split "`n"
    $afterLines  = $scheduleText -split "`n"


#    Write-Output "------------------------------------------------------------"
#    Write-Output $beforeLines
#    Write-Output "------------------------------------------------------------"
#    Write-Output $afterLines
#    Write-Output "------------------------------------------------------------"


#    Write-Output $output

    # 新しいデータをファイルに上書き
    $scheduleText | Out-File -FilePath $filePath -Encoding UTF8

# 結果を格納する配列
$addedLines = @()
$removedLines = @()
$changedLines = @()

# 比較のためにハッシュテーブルを作成
$oldDataHash = @{}
for ($i = 0; $i -lt $beforeLines.Length; $i++) {
    $oldDataHash[$i] = $beforeLines[$i]
}

$scheduleTextHash = @{}
for ($i = 0; $i -lt $afterLines.Length; $i++) {
    $scheduleTextHash[$i] = $afterLines[$i]
}

# 行ごとに比較
$maxLines = [math]::Max($beforeLines.Count, $afterLines.Count)
for ($i = 0; $i -lt $maxLines; $i++) {
    $beforeLine = $oldDataHash[$i]
    $afterLine = $scheduleTextHash[$i]

    if ($beforeLine -ne $afterLine) {
        if ($beforeLine -and -not $afterLine) {
            $removedLines += $beforeLine
        } elseif ($afterLine -and -not $beforeLine) {
            $addedLines += $afterLine
        } else {
            $changedLines += "Before: $beforeLine -> After: $afterLine"
        }
    }
}

# 結果を出力
Write-Host "=== Added Lines ==="
$addedLines | ForEach-Object { Write-Host $_ }
Write-Host "`n=== Removed Lines ==="
$removedLines | ForEach-Object { Write-Host $_ }
Write-Host "`n=== Changed Lines ==="
$changedLines | ForEach-Object { Write-Host $_ }



}
