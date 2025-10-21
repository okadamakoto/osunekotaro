Add-Type -AssemblyName System.Speech

$speak = New-Object System.Speech.Synthesis.SpeechSynthesizer
$speak.SelectVoice("Microsoft Haruka Desktop")
$speak.Rate = -2

# 出力先ファイル
$outputPath = "C:\okada\text\基本情報技術者試験.wav"
$textPath = "C:\okada\text\基本情報技術者試験.txt"

# SJISでテキストを読み込む
$encoding = [System.Text.Encoding]::GetEncoding("shift_jis")
$reader = New-Object System.IO.StreamReader($textPath, $encoding)
$text = $reader.ReadToEnd()
$reader.Close()

# 音声ファイルに出力
$speak.SetOutputToWaveFile($outputPath)
$speak.Speak($text)
$speak.Dispose()