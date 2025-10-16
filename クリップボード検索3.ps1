# クリップボードの内容を取得
$clipboardText = Get-Clipboard

# 検索パターンを作成
$searchPattern = "*$clipboardText*"

Write-Output "検索語: $clipboardText"
Write-Output "検索パターン: $searchPattern"

# 検索対象のドライブ
$drives = @("G:\", "H:\", "I:\", "J:\", "K:\", "L:\")

# 該当フォルダのリスト
$matchedFolders = @()

# 各ドライブを検索
foreach ($drive in $drives) {
    # フォルダのみ対象に検索
    $folders = Get-ChildItem -Path $drive -Recurse -Directory -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -like $searchPattern }

    foreach ($folder in $folders) {
        Write-Output "`n★★ フォルダ見つかりました: $($folder.FullName)"
        $matchedFolders += $folder.FullName

        # フォルダ内のファイルを表示
        $files = Get-ChildItem -Path $folder.FullName -File -ErrorAction SilentlyContinue
        foreach ($file in $files) {
            Write-Output "  → $($file.Name)"
        }
    }
}

if ($matchedFolders.Count -eq 0) {
    Write-Output "`n該当フォルダは見つかりませんでした。"
}


#pause

Write-Host "続行するには何かキーを押してください..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
