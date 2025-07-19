<#
.SYNOPSIS
    Interactive WPF GUI with individual buttons for Windows 11 Troubleshoot-related settings pages.

.DESCRIPTION
    Each button opens a separate troubleshoot-related settings page or MMC snap-in and logs the action.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-19
    Version     : 1.0

.NOTES
    Requires PowerShell 5.1+, Windows 11 24H2+, admin rights for event log creation.
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

function Log-Action {
    param ([string]$message)
    $logName = "Application"
    $source = "PowerShell - Troubleshoot Settings Script"
    if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
        try { New-EventLog -LogName $logName -Source $source } catch { Write-Warning "Run as admin to enable event logging." }
    }
    Write-EventLog -LogName $logName -Source $source -EntryType Information -EventId 1000 -Message $message
}

# Create main window
$window = New-Object System.Windows.Window
$window.Title = "Windows 11 Troubleshoot Settings Dashboard"

# Let window size itself based on content
$window.SizeToContent = 'WidthAndHeight'

$window.ResizeMode = [System.Windows.ResizeMode]::NoResize
$window.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterScreen

$stackPanel = New-Object System.Windows.Controls.StackPanel
$stackPanel.Orientation = [System.Windows.Controls.Orientation]::Vertical
$stackPanel.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$stackPanel.VerticalAlignment = [System.Windows.VerticalAlignment]::Center
$window.Content = $stackPanel

$textBlockHeader = New-Object System.Windows.Controls.TextBlock
$textBlockHeader.Text = "Windows 11 Troubleshoot Settings Dashboard"
$textBlockHeader.FontSize = 14
$textBlockHeader.FontWeight = [System.Windows.FontWeights]::Bold
$textBlockHeader.TextAlignment = [System.Windows.TextAlignment]::Center
$textBlockHeader.Margin = [System.Windows.Thickness]::new(0, 0, 0, 20)
$stackPanel.Children.Add($textBlockHeader)

$buttonPanel = New-Object System.Windows.Controls.StackPanel
$buttonPanel.Orientation = [System.Windows.Controls.Orientation]::Vertical
$buttonPanel.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$stackPanel.Children.Add($buttonPanel)

# Button: Open 'Troubleshoot' Settings (ms-settings)
$buttonTroubleshoot = New-Object System.Windows.Controls.Button
$buttonTroubleshoot.Content = "Open 'Troubleshoot' Settings"
$buttonTroubleshoot.Width = 320
$buttonTroubleshoot.Margin = [System.Windows.Thickness]::new(10)
$buttonTroubleshoot.Add_Click({
    Start-Process "ms-settings:troubleshoot"
    Log-Action "Opened 'Troubleshoot' settings via PowerShell script."
})

# Button: Open Device Manager (devmgmt.msc)
$buttonDeviceManager = New-Object System.Windows.Controls.Button
$buttonDeviceManager.Content = "Open Device Manager"
$buttonDeviceManager.Width = 320
$buttonDeviceManager.Margin = [System.Windows.Thickness]::new(10)
$buttonDeviceManager.Add_Click({
    Start-Process "devmgmt.msc"
    Log-Action "Opened Device Manager via PowerShell script."
})

# Button: Open Network Troubleshooter (ncpa.cpl or Network Connections)
$buttonNetworkConnections = New-Object System.Windows.Controls.Button
$buttonNetworkConnections.Content = "Open Network Connections"
$buttonNetworkConnections.Width = 320
$buttonNetworkConnections.Margin = [System.Windows.Thickness]::new(10)
$buttonNetworkConnections.Add_Click({
    Start-Process "ncpa.cpl"
    Log-Action "Opened Network Connections via PowerShell script."
})

# Button: Open Windows Update Troubleshooter (wuapp.exe or settings URI fallback)
$buttonUpdateTroubleshooter = New-Object System.Windows.Controls.Button
$buttonUpdateTroubleshooter.Content = "Open Windows Update Troubleshooter"
$buttonUpdateTroubleshooter.Width = 320
$buttonUpdateTroubleshooter.Margin = [System.Windows.Thickness]::new(10)
$buttonUpdateTroubleshooter.Add_Click({
    # Windows Update Troubleshooter has no direct .msc; open troubleshooter page instead
    Start-Process "ms-settings:troubleshoot-windowsupdate"
    Log-Action "Opened Windows Update Troubleshooter via PowerShell script."
})

# Button: Open Bluetooth Troubleshooter (bthprops.cpl or Devices & Printers)
$buttonBluetooth = New-Object System.Windows.Controls.Button
$buttonBluetooth.Content = "Open Bluetooth Settings"
$buttonBluetooth.Width = 320
$buttonBluetooth.Margin = [System.Windows.Thickness]::new(10)
$buttonBluetooth.Add_Click({
    Start-Process "ms-settings:bluetooth"
    Log-Action "Opened Bluetooth Settings via PowerShell script."
})

# Button: Open Keyboard Troubleshooter (no direct .msc - open Device Manager or Settings)
$buttonKeyboard = New-Object System.Windows.Controls.Button
$buttonKeyboard.Content = "Open Device Manager (Keyboard)"
$buttonKeyboard.Width = 320
$buttonKeyboard.Margin = [System.Windows.Thickness]::new(10)
$buttonKeyboard.Add_Click({
    Start-Process "devmgmt.msc"
    Log-Action "Opened Device Manager via PowerShell script."
})

# Button: Open Power Troubleshooter (powercfg.cpl or power troubleshooter)
$buttonPower = New-Object System.Windows.Controls.Button
$buttonPower.Content = "Open Power Settings"
$buttonPower.Width = 320
$buttonPower.Margin = [System.Windows.Thickness]::new(10)
$buttonPower.Add_Click({
    Start-Process "powercfg.cpl"
    Log-Action "Opened Power Settings via PowerShell script."
})

# Add buttons to panel
$buttonPanel.Children.Add($buttonTroubleshoot)
$buttonPanel.Children.Add($buttonDeviceManager)
$buttonPanel.Children.Add($buttonNetworkConnections)
$buttonPanel.Children.Add($buttonUpdateTroubleshooter)
$buttonPanel.Children.Add($buttonBluetooth)
$buttonPanel.Children.Add($buttonKeyboard)
$buttonPanel.Children.Add($buttonPower)

# Footer
$textBlockFooter = New-Object System.Windows.Controls.TextBlock
$textBlockFooter.Text = "Allester Padovani, Senior IT Specialist. All rights reserved."
$textBlockFooter.FontSize = 12
$textBlockFooter.FontStyle = [System.Windows.FontStyles]::Italic
$textBlockFooter.Foreground = [System.Windows.Media.Brushes]::Black
$textBlockFooter.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$textBlockFooter.Margin = [System.Windows.Thickness]::new(0, 20, 0, 5)
$stackPanel.Children.Add($textBlockFooter)

$window.ShowDialog()
