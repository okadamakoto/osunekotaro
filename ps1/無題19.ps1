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

    # Google Chrome のユーザーエージェントを指定
    $headers = @{
        "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
    }

    # WebページのHTMLを取得
    try {
        $response = Invoke-WebRequest -Uri $url -Headers $headers -UseBasicParsing
        $html = $response.Content

        # タイトルを抽出
        if ($html -match "<title>(.*?)</title>") {
            $title = $matches[1]
            Set-Clipboard -Value $title
            Write-Output "タイトルをクリップボードにコピーしました: $title"
        } else {
            Write-Output "タイトルを取得できませんでした。"
        }
    } catch {
        Write-Output "エラー: Webページの取得に失敗しました。"
    }
} else {
    Write-Output "クリップボードの内容が無効な形式です（例: HMN-108）"
    exit
}
