Add-Type -AssemblyName System.Speech

$speak = New-Object System.Speech.Synthesis.SpeechSynthesizer

# 音声（例：日本語音声を指定。必要なら省略可）
$speak.SelectVoice("Microsoft Haruka Desktop")

# 読み上げ速度をゆっくりに設定
$speak.Rate = -2

# 出力先をWAVファイルに設定（フルパスOK）
$speak.SetOutputToWaveFile("C:\Users\osune\OneDrive\Documents\はじめてのデリヘル.wav")

# テキストを読み込んで読み上げ（フルパスOK）
$speak.Speak([IO.File]::ReadAllText("C:\Users\osune\OneDrive\Documents\はじめてのデリヘル.txt"))

# 後片付け
$speak.Dispose()
