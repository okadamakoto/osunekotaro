# Windows Formsのアセンブリをロード
Add-Type -AssemblyName System.Windows.Forms

# フォームの作成
$form = New-Object System.Windows.Forms.Form
$form.Text = "選択メニュー"
$form.Size = New-Object System.Drawing.Size(300,200)

# フォームを画面中央に表示する設定
$form.StartPosition = "CenterScreen"

# ラベルの作成
$label = New-Object System.Windows.Forms.Label
$label.Text = "どの選択肢を選びますか？"
$label.AutoSize = $true
$label.Location = New-Object System.Drawing.Point(50,20)
$form.Controls.Add($label)

# ボタンAの作成
$buttonA = New-Object System.Windows.Forms.Button
$buttonA.Text = "選択肢A"
$buttonA.Location = New-Object System.Drawing.Point(50,50)
$buttonA.Add_Click({
    [System.Windows.Forms.MessageBox]::Show("選択肢Aが選ばれました")
    $form.Close()  # フォームを閉じる
})
$form.Controls.Add($buttonA)

# ボタンBの作成
$buttonB = New-Object System.Windows.Forms.Button
$buttonB.Text = "選択肢B"
$buttonB.Location = New-Object System.Drawing.Point(50,80)
$buttonB.Add_Click({
    [System.Windows.Forms.MessageBox]::Show("選択肢Bが選ばれました")
    $form.Close()  # フォームを閉じる
})
$form.Controls.Add($buttonB)

# ボタンCの作成
$buttonC = New-Object System.Windows.Forms.Button
$buttonC.Text = "選択肢C"
$buttonC.Location = New-Object System.Drawing.Point(50,110)
$buttonC.Add_Click({
    [System.Windows.Forms.MessageBox]::Show("選択肢Cが選ばれました")
    $form.Close()  # フォームを閉じる
})
$form.Controls.Add($buttonC)

# フォームの表示
$form.ShowDialog()
