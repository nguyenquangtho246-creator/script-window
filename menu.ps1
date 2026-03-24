Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- CẤU HÌNH GIAO DIỆN ---
$form = New-Object System.Windows.Forms.Form
$form.Text = "Tho Tools"
$form.Size = New-Object System.Drawing.Size(500, 350)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "None" # Xóa viền Windows mặc định
$form.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30) # Nền tối

# --- TẠO VIỀN TRẮNG ---
$form.Paint += {
    param($sender, $e)
    $rect = $sender.ClientRectangle
    $rect.Width -= 1
    $rect.Height -= 1
    $e.Graphics.DrawRectangle([System.Drawing.Pen]::new([System.Drawing.Color]::White, 2), $rect)
}

# --- CHO PHÉP KÉO MENU (DRAG FORM) ---
$mouseDown = $false
$form.Add_MouseDown({ $global:mouseDown = $true; $global:initialPos = [System.Windows.Forms.Cursor]::Position; $global:formPos = $form.Location })
$form.Add_MouseMove({
    if ($global:mouseDown) {
        $delta = [System.Drawing.Point]::Subtract([System.Windows.Forms.Cursor]::Position, $global:initialPos)
        $form.Location = [System.Drawing.Point]::Add($global:formPos, $delta)
    }
})
$form.Add_MouseUp({ $global:mouseDown = $false })

# --- TIÊU ĐỀ ---
$title = New-Object System.Windows.Forms.Label
$title.Text = "THO TOOLS"
$title.ForeColor = "White"
$title.Font = New-Object System.Drawing.Font("Consolas", 14, [System.Drawing.FontStyle]::Bold)
$title.Location = New-Object System.Drawing.Point(180, 15)
$title.AutoSize = $true
$form.Controls.Add($title)

# --- CỘT TRÁI: CHỨC NĂNG ---
$labelLeft = New-Object System.Windows.Forms.Label
$labelLeft.Text = "[ FUNCTIONS ]"
$labelLeft.ForeColor = "Cyan"
$labelLeft.Location = New-Object System.Drawing.Point(30, 60)
$form.Controls.Add($labelLeft)

# Nút FPS Booster
$btnFPS = New-Object System.Windows.Forms.CheckBox
$btnFPS.Text = "FPS Booster"
$btnFPS.ForeColor = "White"
$btnFPS.Location = New-Object System.Drawing.Point(30, 90)
$form.Controls.Add($btnFPS)

# Nút Boost Ping (Tối ưu thật)
$btnPing = New-Object System.Windows.Forms.CheckBox
$btnPing.Text = "Boost Ping"
$btnPing.ForeColor = "White"
$btnPing.Location = New-Object System.Drawing.Point(30, 120)
$btnPing.Add_Click({
    if($btnPing.Checked) {
        # Tối ưu hóa Network cơ bản (An toàn)
        netsh int tcp set global autotuninglevel=normal
        netsh int tcp set global chimney=enabled
    }
})
$form.Controls.Add($btnPing)

# Nút Open Command (Mở CMD thật)
$btnCMD = New-Object System.Windows.Forms.Button
$btnCMD.Text = "Open Command"
$btnCMD.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
$btnCMD.ForeColor = "White"
$btnCMD.FlatStyle = "Flat"
$btnCMD.Location = New-Object System.Drawing.Point(30, 160)
$btnCMD.Add_Click({ Start-Process cmd.exe })
$form.Controls.Add($btnCMD)

# --- CỘT PHẢI: SETTINGS ---
$labelRight = New-Object System.Windows.Forms.Label
$labelRight.Text = "[ SETTINGS ]"
$labelRight.ForeColor = "Cyan"
$labelRight.Location = New-Object System.Drawing.Point(280, 60)
$form.Controls.Add($labelRight)

$labelDpi = New-Object System.Windows.Forms.Label
$labelDpi.Text = "Dpi Booster (1-3):"
$labelDpi.ForeColor = "White"
$labelDpi.Location = New-Object System.Drawing.Point(280, 90)
$labelDpi.AutoSize = $true
$form.Controls.Add($labelDpi)

$trackBar = New-Object System.Windows.Forms.TrackBar
$trackBar.Minimum = 1
$trackBar.Maximum = 3
$trackBar.Value = 1
$trackBar.Location = New-Object System.Drawing.Point(280, 120)
$trackBar.Width = 150
$trackBar.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
$form.Controls.Add($trackBar)

# --- NÚT ĐÓNG (EXIT) ---
$btnClose = New-Object System.Windows.Forms.Button
$btnClose.Text = "X"
$btnClose.Size = New-Object System.Drawing.Size(25, 25)
$btnClose.Location = New-Object System.Drawing.Point(465, 5)
$btnClose.FlatStyle = "Flat"
$btnClose.ForeColor = "Red"
$btnClose.Add_Click({ $form.Close() })
$form.Controls.Add($btnClose)

# Hiển thị Menu
$form.ShowDialog()
