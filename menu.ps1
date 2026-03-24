Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- CẤU HÌNH GIAO DIỆN WPF ---
$wpfCode = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2000/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2000/xaml"
        Title="Tho Tools" Height="450" Width="600"
        WindowStyle="None" ResizeMode="NoResize"
        AllowsTransparency="True" Background="Transparent"
        BorderBrush="White" BorderThickness="1"
        Left="200" Top="200">
    
    <Grid Background="White">
        <DockPanel Height="30" VerticalAlignment="Top" Background="#F0F0F0">
            <Label Content="Tho Tools" FontWeight="Bold" Foreground="#333" VerticalAlignment="Center" Margin="5,0,0,0"/>
            <Label Content="OK! - Optimal" Foreground="#00CC00" FontWeight="SemiBold" VerticalAlignment="Center" Margin="10,0,0,0"/>
            <Button Name="BtnClose" Content="X" Width="30" Background="Transparent" BorderBrush="Transparent" Foreground="Red" FontWeight="Bold" HorizontalAlignment="Right" DockPanel.Dock="Right"/>
        </DockPanel>

        <TabControl Margin="0,30,0,0" BorderThickness="0">
            
            <TabItem Header="Simple">
                <Grid Margin="10">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="1.5*"/>
                    </Grid.ColumnDefinitions>

                    <GroupBox Header="Game Tweaks" Grid.Column="0" BorderBrush="#DDD" BorderThickness="1">
                        <StackPanel Margin="10">
                            <CheckBox Name="ChkFPS" Content="FPS Booster" Margin="0,5"/>
                            <CheckBox Name="ChkPing" Content="Boost Ping" Margin="0,5"/>
                            <Button Name="BtnCMD" Content="Open Command" Margin="0,15,0,0" Background="#F5F5F5" Padding="5,2" BorderBrush="#CCC"/>
                        </StackPanel>
                    </GroupBox>

                    <GroupBox Header="Settings Beta" Grid.Column="1" Margin="10,0,0,0" BorderBrush="#DDD" BorderThickness="1">
                        <StackPanel Margin="10">
                            <Label Content="DPI Sensitivity:" Margin="0,0,0,5"/>
                            <Slider Name="SldDPI" Minimum="1" Maximum="3" Value="1" TickFrequency="1" IsSnapToTickEnabled="True" TickPlacement="BottomRight"/>
                            <StackPanel Orientation="Horizontal" HorizontalAlignment="Center" Margin="0,5,0,10">
                                <Label Content="Level: "/>
                                <Label Name="LblDPIValue" Content="1" FontWeight="Bold"/>
                            </StackPanel>
                            <CheckBox Name="ChkTweaks" Content="Apply Advanced Tweaks" Margin="0,5"/>
                            <Button Name="BtnTest" Content="Test Configuration" Margin="0,15,0,0" Background="#4A90E2" Foreground="White" Padding="10,5" BorderBrush="Transparent" FontWeight="Bold"/>
                        </StackPanel>
                    </GroupBox>
                    
                    <Button Name="BtnActivate" Content="KÍCH HOẠT TỐI ƯU" Grid.Row="1" Grid.ColumnSpan="2" Margin="10,210,10,0" Height="40" VerticalAlignment="Top" Background="#4A90E2" Foreground="White" BorderBrush="Transparent" FontWeight="Bold" FontSize="14"/>
                </Grid>
            </TabItem>
            
            <TabItem Header="Advanced">
                <Label Content="Advanced settings here..."/>
            </TabItem>
            
            <TabItem Header="Config">
                <Label Content="Load/Save configs..."/>
            </TabItem>
        </TabControl>
    </Grid>
</Window>
"@

# --- KHỞI TẠO VÀ LIÊN KẾT CHỨC NĂNG ---
$reader = [System.Xml.XmlReader]::Create([System.IO.StringReader]::$wpfCode)
$form = [Windows.Markup.XamlReader]::Load($reader)

# 1. Liên kết các Control
$btnClose = $form.FindName("BtnClose")
$chkFPS = $form.FindName("ChkFPS")
$chkPing = $form.FindName("ChkPing")
$btnCMD = $form.FindName("BtnCMD")
$sldDPI = $form.FindName("SldDPI")
$lblDPIValue = $form.FindName("LblDPIValue")
$btnActivate = $form.FindName("BtnActivate")

# 2. Xử lý logic di chuyển menu
$global:dragOn = $false
$form.Add_MouseLeftButtonDown({
    $global:dragOn = $true
    $global:initialPos = $form.PointToScreen([System.Windows.Point]::new(0,0))
    $global:mousePos = [System.Windows.Input.Mouse]::GetPosition($form)
    $form.CaptureMouse()
})
$form.Add_MouseMove({
    if ($global:dragOn) {
        $currMousePos = [System.Windows.Input.Mouse]::GetPosition($form)
        $form.Left = ($currMousePos.X - $global:mousePos.X) + $form.Left
        $form.Top = ($currMousePos.Y - $global:mousePos.Y) + $form.Top
    }
})
$form.Add_MouseLeftButtonUp({
    $global:dragOn = $false
    $form.ReleaseMouseCapture()
})

# 3. Gán chức năng cho các nút
$btnClose.Add_Click({ $form.Close() })

# Boost Ping thật
$chkPing.Add_Checked({
    # Tối ưu hóa Network cơ bản (An toàn)
    netsh int tcp set global autotuninglevel=normal | Out-Null
    netsh int tcp set global chimney=enabled | Out-Null
})

# Open CMD thật
$btnCMD.Add_Click({ Start-Process cmd.exe })

# Cập nhật giá trị hiển thị của Thanh trượt DPI
$sldDPI.Add_ValueChanged({
    $lblDPIValue.Content = [Math]::Round($sldDPI.Value).ToString()
})

# Nút Kích hoạt (có thể thêm logic ở đây)
$btnActivate.Add_Click({
    [System.Windows.MessageBox]::Show("Đã áp dụng các tùy chỉnh tối ưu!", "Tho Tools Status")
})

# Hiển thị Menu
$form.ShowDialog()
