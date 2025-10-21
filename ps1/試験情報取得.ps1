# 試験IDのリスト
#$examIDs = @("05_haru", "05_aki", "06_haru", "06_aki", "07_haru")  # 例として他の試験IDも追加

#
$examIDs = @(
, "06_haru"
, "05_haru"
)  # 例として他の試験IDも追加

#fe
$examIDs = @(
,"06_haru"
,"05_haru"
,"04_menjo"
,"03_menjo"
,"02_menjo"
,"01_aki"
,"31_haru"
,"30_aki"
,"30_haru"
,"29_aki"
,"29_haru"
,"28_aki"
,"28_haru"
,"27_aki"
,"27_haru"
,"26_aki"
,"26_haru"
,"25_aki"
,"25_haru"
,"24_aki"
,"24_haru"
,"23_aki"
,"23_toku"
,"22_aki"
,"22_haru"
,"21_aki"
,"21_haru"
,"20_aki"
,"20_haru"
,"19_aki"
,"19_haru"
,"18_aki"
,"18_haru"
,"17_aki"
,"17_haru"
,"16_aki"
,"16_haru"
,"15_aki"
,"15_haru"
,"14_aki"
,"14_haru"
,"13_aki"
,"13_haru"
)  # 例として他の試験IDも追加

#ap
$examIDs = @(
  "07_haru"
, "06_aki"
, "06_haru"
, "05_aki" 
, "05_haru"
, "04_aki" 
, "04_haru"
, "03_aki" 
, "03_haru"
, "02_aki" 
, "02_haru"
, "01_aki" 
, "31_haru"
, "30_aki" 
, "30_haru"
, "29_aki" 
, "29_haru"
, "28_aki" 
, "28_haru"
, "27_aki" 
, "27_haru"
, "26_aki" 
, "26_haru"
, "25_aki" 
, "25_haru"
, "24_aki" 
, "24_haru"
, "23_aki" 
, "23_toku"
, "22_aki" 
, "22_haru"
, "21_aki" 
, "21_haru"
, "20_aki" 
, "20_haru"
, "19_aki" 
, "19_haru"
, "18_aki" 
, "18_haru"
, "17_aki" 
, "17_haru"
, "16_haru"
, "15_haru"
)  # 例として他の試験IDも追加



$TestLabel = "ap"
#$TestLabel = "fe"

foreach ($examID in $examIDs) {
    $url2 = "https://www.$TestLabel-siken.com/kakomon/$examID/"
    #https://www.fe-siken.com/kakomon/06_haru/

    # Webページ取得
    $content = Invoke-WebRequest -Uri "$url2"

    # qtable部分を抽出
    $qtablePattern = '(?s)<table class="qtable">(.*?)</table>'
    if ($content.Content -match $qtablePattern) {
        $qtableHtml = $matches[1]

        # リンクと問題タイトルを抽出
#        $rowPattern = '<a href="([^"]+)">([^<]+)</a><td>([^<]+)'
#        $matchesList = [regex]::Matches($qtableHtml, $rowPattern)
        $rowPattern = '<a href="([^"]+)">([^<]+)</a><td>([^<]+)<td>([^<]+)'
        $matchesList = [regex]::Matches($qtableHtml, $rowPattern)

        $results = @()
        foreach ($match in $matchesList) {
            $url = $match.Groups[1].Value
            $qno = $match.Groups[2].Value -replace '[^\d]', ''  # 数字だけ抽出
            $gaiyo = $match.Groups[3].Value
            $label = $match.Groups[4].Value

            $results += [PSCustomObject]@{
                試験 = "$TestLabel-$examID"
                番号 = $qno
                概要 = $gaiyo
                分類 = $label
                URL = "https://www.$TestLabel-siken.com/kakomon/$examID/$url"
            }
        }

        # 結果をCSVに出力
        $results | Export-Csv -Path "$TestLabel-$examID.csv" -NoTypeInformation -Encoding UTF8
    } else {
        Write-Host "$examID のqtableが見つかりませんでした"
    }
}
