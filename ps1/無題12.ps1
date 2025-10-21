# 変数の設定
$url = "https://www.cityheaven.net/chiba/A1203/A120302/mken/girlid-40700379/?pcmode=sp"

# URLからHTMLソースを取得
$response = Invoke-WebRequest -Uri $url
$htmlContent = $response.Content

# 必要な部分を抽出する正規表現
$regex = [regex]::new('<div class="drawer_popup drawer_syukin">(.*?)<div class="gh_bg_front_syukin dp_close_syukin">', [System.Text.RegularExpressions.RegexOptions]::Singleline)
$match = $regex.Match($htmlContent)

if ($match.Success) {
    $scheduleHtml = $match.Groups[1].Value

    # HTMLタグを取り除く
    $scheduleText = [regex]::Replace($scheduleHtml, '<.*?>', '')

    Write-Host "$scheduleText"

} else {
    Write-Host "指定された部分が見つかりませんでした。"
}
