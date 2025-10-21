# 指定したURLからHTMLソースを取得する
$url = "https://www.ap-siken.com/kakomon/29_aki/q18.html"  # ここにURLを指定してください

# URLからHTMLソースを取得
$html = Invoke-WebRequest -Uri $url

# HTMLのContentから正規表現で対象部分を抽出
# <div class="main kako"><h2>応用情報技術者平成29年秋期 午前問18</h2> の部分を抽出
$pattern = '<div class="main kako"><h2>(.*?)</h2>'

# 正規表現でマッチさせる
if ($html.Content -match $pattern) {
    $result = $matches[1]  # マッチした部分のグループを取得
    Write-Output $result
} else {
    Write-Output "指定した要素が見つかりませんでした。"
}

#<h3 class="qno">問18<div id="calcBtn"></div></h3><div id="mondai">CPUスケジューリングにおけるラウンドロビンスケジューリング方式に関する記述として，適切なものはどれか。</div><div class="ansbg" style="margin:10px 0 50px"><ul class="selectList col1"><li><button class="selectBtn">ア</button><span id="select_a">自動制御システムなど，リアルタイムシステムのスケジューリングに適している。</span></li><li><button class="selectBtn">イ</button><span id="select_i">タイマ機能のないシステムにおいても，簡単に実現することができる。</span></li><li><button class="selectBtn" id="t">ウ</button><span id="select_u">タイムシェアリングシステムのスケジューリングに適している。</span></li><li><button class="selectBtn">エ</button><span id="select_e">タスクに優先順位をつけることによって，容易に実現することができる。</span></li></ul></div>
$pattern = '<h3 class="qno">(.*?)<div id="calcBtn"></div></h3>'

# 正規表現でマッチさせる
if ($html.Content -match $pattern) {
    $result = $matches[1]  # マッチした部分のグループを取得
    Write-Output $result
} else {
    Write-Output "指定した要素が見つかりませんでした。"
}

#<h3 class="qno">問18<div id="calcBtn"></div></h3><div id="mondai">CPUスケジューリングにおけるラウンドロビンスケジューリング方式に関する記述として，適切なものはどれか。</div><div class="ansbg" style="margin:10px 0 50px"><ul class="selectList col1"><li><button class="selectBtn">ア</button><span id="select_a">自動制御システムなど，リアルタイムシステムのスケジューリングに適している。</span></li><li><button class="selectBtn">イ</button><span id="select_i">タイマ機能のないシステムにおいても，簡単に実現することができる。</span></li><li><button class="selectBtn" id="t">ウ</button><span id="select_u">タイムシェアリングシステムのスケジューリングに適している。</span></li><li><button class="selectBtn">エ</button><span id="select_e">タスクに優先順位をつけることによって，容易に実現することができる。</span></li></ul></div>
$pattern = '<div id="mondai">(.*?)</div>'

# 正規表現でマッチさせる
if ($html.Content -match $pattern) {
    $result = $matches[1]  # マッチした部分のグループを取得
    Write-Output $result
} else {
    Write-Output "指定した要素が見つかりませんでした。"
}
