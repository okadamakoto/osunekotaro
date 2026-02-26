# ==========================================
# LockClassTEST2 停止 → WiFi再起動 → 再起動
# ==========================================

# 管理者昇格チェック
if (-not ([Security.Principal.WindowsPrincipal] 
    [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator)) {

    Write-Host "管理者権限で再起動します..."
    Start-Process powershell "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$stopPath = "C:\Users\osune\Downloads\stop.txt2"
$vbsPath  = "C:\Users\osune\Downloads\LockClassTEST2.VBS"

Write-Host "==== WiFi再起動処理開始 ===="

# ================================
# ① 停止指示
# ================================

New-Item $stopPath -ItemType File -Force | Out-Null
Write-Host "停止指示送信"

# ================================
# ② VBS終了待ち
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

$wifi = Get-NetAdapter |
Where-Object {
    $_.Status -ne "Disabled" -and
    $_.PhysicalMediaType -like "*802.11*"
} |
Select-Object -First 1

if ($wifi) {

    Write-Host "WiFi再起動:" $wifi.Name

    Restart-NetAdapter -Name $wifi.Name -Confirm:$false

    # ----------------------------
    # ★ インターネット復帰待ち（Ping方式）
    # ----------------------------

    Write-Host "接続復帰待ち..."

    $timeout = 60
    $elapsed = 0

    while ($elapsed -lt $timeout) {

        if (Test-Connection 8.8.8.8 -Quiet -Count 1) {
            Write-Host "インターネット接続確認"
            break
        }

        Start-Sleep 1
        $elapsed++
    }

    if ($elapsed -ge $timeout) {
        Write-Host "接続確認タイムアウト"
    }

} else {

    Write-Host "WiFiアダプタが見つかりません"
}

# ================================
# ④ stop.txt削除
# ================================

Remove-Item $stopPath -Force -ErrorAction SilentlyContinue
Write-Host "停止ファイル削除"

# ================================
# ⑤ VBS再起動（標準権限）
# ================================

Start-Process explorer.exe "`"$vbsPath`""
Write-Host "VBS再起動完了"

Write-Host "==== 処理終了 ===="