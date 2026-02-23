# ==========================================
# LockClassTEST2 停止 → WiFi再起動 → 再起動
# ==========================================

$stopPath = "C:\Users\osune\Downloads\stop.txt2"
$vbsPath  = "C:\Users\osune\Downloads\LockClassTEST2.VBS"

Write-Host "==== WiFi再起動処理開始 ===="

# ================================
# ① stop.txt 作成（停止指示）
# ================================

New-Item $stopPath -ItemType File -Force | Out-Null
Write-Host "停止指示送信"


# ================================
# ② VBS終了待ち（wscriptのみ検知）
# ================================

Write-Host "VBS終了待ち..."

while (Get-CimInstance Win32_Process | Where-Object {
    $_.Name -eq "wscript.exe" -and $_.CommandLine -match "LockClassTEST2.vbs"
}) {
    Start-Sleep -Milliseconds 300
}

Write-Host "VBS停止確認"


# ================================
# ③ WiFi再起動
# ================================

$wifi = Get-NetAdapter | Where-Object {
    $_.InterfaceDescription -match "Wireless"
}

if ($wifi) {

    Write-Host "WiFi再起動:" $wifi.Name

    Restart-NetAdapter -Name $wifi.Name -Confirm:$false -ErrorAction SilentlyContinue

    # 復帰待ち
    Write-Host "接続復帰待ち..."

    while ((Get-NetAdapter -Name $wifi.Name).Status -ne "Up") {
        Start-Sleep -Seconds 1
    }

    Write-Host "WiFi復帰確認"

} else {

    Write-Host "WiFiアダプタが見つかりません"
}


# ================================
# ④ stop.txt削除
# ================================

Remove-Item $stopPath -Force -ErrorAction SilentlyContinue
Write-Host "停止ファイル削除"


# ================================
# ⑤ VBS再起動
# ================================

Start-Process explorer.exe "`"$vbsPath`""
Write-Host "VBS再起動完了"


Write-Host "==== 処理終了 ===="