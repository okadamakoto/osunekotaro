param(
    [Parameter(Mandatory=$true)]
    [string]$ExamId
)

# URLと出力ファイル名を試験IDから自動生成
$url = "https://www.ap-siken.com/kakomon/$ExamId/"
$outputCsv = "$ExamId.csv"

Write-Output "URL: $url"
Write-Output "出力ファイル: $outputCsv"

# HTMLを取得
try {
    $html = Invoke-WebRequest -Uri $url -UseBasicParsing
} catch {
    Write-Error "指定URLからHTMLを取得できませんでした: $url"
    exit 1
}
$content = $html.Content

# <tr class="h"><th colspan="4">ブロック抽出
$pattern = '(?s)<tr class="h"><th colspan="4">.*?</tr>'
$matches = [regex]::Matches($content, $pattern)

if ($matches.Count -eq 0) {
    Write-Error "対象の<tr>ブロックが見つかりませんでした。URLやサイト構造を確認してください。"
    exit 1
}

# データ抽出
$result = @()

foreach ($match in $matches) {
    $block = $match.Value

    # 小問ごとのパターン抽出
    $qPattern = '(?s)<a href="q(\d+)\.html">問\d+</a>.*?<td>(.*?)</td>.*?<td>(.*?)</td>'
    $qMatches = [regex]::Matches($block, $qPattern)

    foreach ($qMatch in $qMatches) {
        $number = $qMatch.Groups[1].Value
        $overview = $qMatch.Groups[2].Value -replace '\s+', ''  # 空白除去
        $category = $qMatch.Groups[3].Value -replace '\s+', ''  # 空白除去

        $line = "$ExamId,$number,$overview,$category"
        $result += $line
    }
}

# ファイルに書き込み（ヘッダーなし）
$result | Set-Content -Encoding UTF8 -Path $outputCsv

Write-Output "CSVファイル '$outputCsv' に出力しました。"
Write-Output "抽出問題数: $($result.Count)"
