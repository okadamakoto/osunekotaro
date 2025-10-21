# DL_monitoring_Start.ps1
# 変数を宣言
$stopPath = "C:\Users\osune\Downloads\stop.txt2"

# ファイルが存在するかチェックし、存在する場合は削除
if (Test-Path $stopPath) {
    Remove-Item $stopPath
}

# LockClassTEST2.ps1を実行
Start-Process -FilePath "powershell.exe" -ArgumentList "-File C:\Path\To\LockClassTEST2.ps1"
