Add-Type -AssemblyName System.Speech

$speak = New-Object System.Speech.Synthesis.SpeechSynthesizer

# 音声（例：日本語音声を指定。必要なら省略可）
$speak.SelectVoice("Microsoft Haruka Desktop")

# 読み上げ速度をゆっくりに設定
$speak.Rate = -2

$speak.Volume = 50

# 出力先をWAVファイルに設定（フルパスOK）
$speak.SetOutputToWaveFile("C:\okada\text\基本情報技術者試験UTF8.wav")

# テキストを読み込んで読み上げ（フルパスOK）
$speak.Speak([IO.File]::ReadAllText("C:\okada\text\基本情報技術者試験UTF8.txt"))

# 後片付け
$speak.Dispose()