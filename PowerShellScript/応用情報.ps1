
$qname="17_haru"
$qname="17_aki"
$qname="18_haru"
$qname="18_aki"
$qname="19_haru"
$qname="19_aki"
$qname="20_haru"
$qname="20_aki"
$qname="21_haru"
$qname="21_aki"
$qname="22_haru"
$qname="22_aki"
$qname="23_toku"
$qname="23_aki"
$qname="24_haru"
$qname="24_aki"
$qname="25_haru"
$qname="25_aki"
$qname="26_haru"
$qname="26_aki"
$qname="27_haru"
$qname="27_aki"
$qname="28_haru"
$qname="28_aki"
$qname="29_haru"
#$qname="29_aki"
$qname="30_haru"
$qname="30_aki"
$qname="31_haru"
$qname="01_aki"
$qname="02_aki"
$qname="03_haru"
$qname="03_aki"
#$qname="04_haru"
#$qname="04_aki"
#$qname="05_haru"
#$qname="05_aki"
$qname="06_haru"
$testList = @("06_aki", "06_haru", "05_aki", "05_haru", "04_aki", "04_haru", "03_aki", "03_haru", "02_aki", "01_aki", "31_haru", "30_aki", "30_haru", "29_haru", "28_aki", "28_haru", "27_aki", "27_haru", "26_aki", "26_haru", "25_aki", "25_haru", "24_aki", "24_haru", "23_aki", "23_toku", "22_aki", "22_haru", "21_aki", "21_haru", "20_aki", "20_haru", "19_aki", "19_haru", "18_aki", "18_haru", "17_aki", "17_haru")

function Add-LogEntry {
    param (
        [string]$message    # ログに書き込むメッセージ
    )

    # ログファイルのパスを固定
    $filePath = "C:\Users\osune\OneDrive\Documents\$qname.txt"

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
Add-LogEntry -message "--------------------------------------------------------------"


# qname.txtファイルから試験名を読み込む
$qnameFilePath = "C:\Users\osune\OneDrive\Documents\qname.txt"
$qname = Get-Content $qnameFilePath


# qno.txtファイルから数字を読み込む
$qnoFilePath = "C:\Users\osune\OneDrive\Documents\qno.txt"
$qno = Get-Content $qnoFilePath

Write-Output "【$qname】"

# リスト内の次の試験名に変更
$index = $testList.IndexOf($qname)
Write-Output "$index"
Write-Output $testList[$index + 1]


# 数字を整数に変換
$qno = [int]$qno

# URLの数字部分を置き換え
$url = "https://www.ap-siken.com/kakomon/$qname/q$qno.html"

# 読み込んだ数字が80未満なら+1、それ以外なら1に変更
if ($qno -lt 80) {
    $qno++
} else {
    $qno = 1
    # リスト内の次の試験名に変更
    $index = $testList.IndexOf($qname)
    Write-Output "$index"
    if ($index -ne -1 -and $index -lt $testList.Count - 1) {
        $qname = $testList[$index + 1]
    } else {
        Write-Output "一致する試験名がリストにないか、最後の試験名です。変更はありません。"
    }
}

# 新しい数字でqno.txtファイルを上書き
$qno | Set-Content $qnoFilePath

# 新しい試験名でqname.txtファイルを上書き
$qname | Set-Content $qnameFilePath


# 対象ページのURLを指定
#$url = "https://www.ap-siken.com/kakomon/29_aki/q15.html" # ここに対象のURLを指定

# URLからHTMLを取得
$response = Invoke-WebRequest -Uri $url

# 必要な要素を抽出
$mainKako = $response.ParsedHtml.getElementsByClassName("main kako").Item(0).innerText
$qno = $response.ParsedHtml.getElementsByClassName("qno").Item(0).innerText.Trim()
$mondai = $response.ParsedHtml.getElementById("mondai").innerText
$selectA = $response.ParsedHtml.getElementById("select_a").innerText
$selectI = $response.ParsedHtml.getElementById("select_i").innerText
$selectU = $response.ParsedHtml.getElementById("select_u").innerText
$selectE = $response.ParsedHtml.getElementById("select_e").innerText
$recentList = $response.ParsedHtml.getElementById("recentList").innerText.Trim()
$answerChar = $response.ParsedHtml.getElementById("answerChar").innerText
$kaisetsu = $response.ParsedHtml.getElementById("kaisetsu").innerText.Trim()

# HTMLのContentから正規表現で対象部分を抽出
# <div class="main kako"><h2>応用情報技術者平成29年秋期 午前問18</h2> の部分を抽出
$pattern = '<div class="main kako"><h2>(.*?)</h2>'

# 正規表現でマッチさせる
$testname = ""
if ($response.Content -match $pattern) {
    $result = $matches[1]  # マッチした部分のグループを取得
    Write-Output $result
    $testname = $result
} else {
    Write-Output "指定した要素が見つかりませんでした。"
}

# 結果を出力
$results = @{
    "main kako" = $mainKako
    "qno" = $qno
    "mondai" = $mondai
    "select_a" = $selectA
    "select_i" = $selectI
    "select_u" = $selectU
    "select_e" = $selectE
    "recentList" = $recentList
    "answerChar" = $answerChar
    "kaisetsu" = $kaisetsu
}

# 出力
$results | Format-Table


# 関数の使用例
Add-LogEntry -message "【試験】$testname"
Add-LogEntry -message "【問題番号】$qno"
Add-LogEntry -message "【問題】$mondai"
Add-LogEntry -message "ア：$selectA"
Add-LogEntry -message "イ：$selectI"
Add-LogEntry -message "ウ：$selectU"
Add-LogEntry -message "エ：$selectE"
Add-LogEntry -message $recentList
Add-LogEntry -message "【正解】$answerChar"
Add-LogEntry -message "【解説】$kaisetsu"

Write-Output "【試験】"$testname
Write-Output "【問題番号】"$qno
Write-Output "【問題】"$mondai
Write-Output "ア："$selectA
Write-Output "イ："$selectI
Write-Output "ウ："$selectU
Write-Output "エ："$selectE
Write-Output $recentList
Write-Output "【正解】"$answerChar
Write-Output "【解説】"$kaisetsu


Write-Output "【試験】"$testname
Write-Output "【問題番号】"$qno
