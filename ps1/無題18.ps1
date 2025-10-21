# クリップボードの内容を取得
$clipboardText = Get-Clipboard

# 正規表現で形式チェック（英字-数字の形式）
if ($clipboardText -match "^([A-Za-z]+)-([0-9]+)$") {
    $prefix = $matches[1]  # 英字部分
    $number = $matches[2]   # 数字部分
    
    # "-" を "00" に置換して新しいIDを作成
    $newId = "$prefix" + "00" + "$number"
    
    # URLを生成
    $url = "https://www.dmm.co.jp/monthly/premium/-/detail/=/cid=$newId/"
    #$url = "https://www.dmm.co.jp/digital/videoa/-/detail/=/cid=$newId/"

    # URLを開く
    Start-Process $url
    
    # Webページのタイトルを取得
    try {
        $web = New-Object -ComObject InternetExplorer.Application
        $web.Visible = $false  # 非表示で開く
        $web.Navigate($url)
        
        while ($web.Busy -or $web.ReadyState -ne 4) {
            Start-Sleep -Milliseconds 500
        }
        
        $title = $web.Document.Title
        $web.Quit()
        
        # タイトルをクリップボードにコピー
        Set-Clipboard -Value $title
        
        Write-Output "タイトルをクリップボードにコピーしました: $title"
    } catch {
        Write-Output "エラー: Webページのタイトルを取得できませんでした。"
    }
} else {
    Write-Output "クリップボードの内容が無効な形式です（例: HMN-108）"
    exit
}
