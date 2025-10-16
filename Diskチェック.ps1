Get-PSDrive -PSProvider FileSystem | ForEach-Object {
    $total = $_.Used + $_.Free
    if ($total -eq 0) {
        $usagePercent = 0
    } else {
        $usagePercent = ($_.Used / $total) * 100
    }

    [PSCustomObject]@{
        'ドライブ名' = $_.Name
        '合計容量GB' = "{0:N2}" -f ($total / 1GB)
        '空き容量GB' = "{0:N2}" -f ($_.Free / 1GB)
        '使用率%'    = "{0:N2}" -f $usagePercent
    }
} | Format-Table -AutoSize
