# 選択肢の表示
Write-Host "選択肢を選んでください:"
Write-Host "1. 選択肢A"
Write-Host "2. 選択肢B"
Write-Host "3. 選択肢C"

# ユーザーからの入力を受け取る
$choice = Read-Host "番号を入力してください"

# 入力された番号に基づいて処理を実行
switch ($choice) {
    1 {
        Write-Host "あなたは選択肢Aを選びました"
    }
    2 {
        Write-Host "あなたは選択肢Bを選びました"
    }
    3 {
        Write-Host "あなたは選択肢Cを選びました"
    }
    default {
        Write-Host "無効な選択です"
    }
}
