<#
.SYNOPSIS
    WASAPI Audio Endpoint Management Dashboard for Windows 11 24H2.

.DESCRIPTION
    Provides a WPF GUI with buttons for Wi-Fi, Ethernet, network troubleshooting and related utilities:
    - Wi-Fi Settings
    - Ethernet Settings
    - Network Troubleshooter
    - System Settings
    - Device Manager
    - Command Prompt
    - Event Viewer

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-20
    Version     : 1.0

.NOTES
    Requires PowerShell 5.1+, Windows 11 24H2 or later.
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Log-Action {
    param ([string]$message, [string]$source = "PowerShell - Network Dashboard")

    $logName = "Application"
    if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
        try { New-EventLog -LogName $logName -Source $source } catch {}
    }

    Write-EventLog -LogName $logName -Source $source -EntryType Information -EventId 1000 -Message $message
}

# Create WPF Window
$window = New-Object System.Windows.Window
$window.Title = "Wi-Fi & Ethernet Management Dashboard"
$window.SizeToContent = 'WidthAndHeight'
$window.ResizeMode = [System.Windows.ResizeMode]::NoResize
$window.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterScreen

# Main stack panel
$stackPanel = New-Object System.Windows.Controls.StackPanel
$stackPanel.Orientation = [System.Windows.Controls.Orientation]::Vertical
$stackPanel.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$stackPanel.VerticalAlignment = [System.Windows.VerticalAlignment]::Center
$window.Content = $stackPanel

# Header
$textBlockHeader = New-Object System.Windows.Controls.TextBlock
$textBlockHeader.Text = "Wi-Fi & Ethernet Management Dashboard"
$textBlockHeader.FontSize = 16
$textBlockHeader.FontWeight = [System.Windows.FontWeights]::Bold
$textBlockHeader.TextAlignment = [System.Windows.TextAlignment]::Center
$textBlockHeader.Margin = [System.Windows.Thickness]::new(0, 0, 0, 20)
$stackPanel.Children.Add($textBlockHeader)

# Wi-Fi Settings button
$buttonWifi = New-Object System.Windows.Controls.Button
$buttonWifi.Content = "Open Wi-Fi Settings"
$buttonWifi.Width = 320
$buttonWifi.Margin = [System.Windows.Thickness]::new(10)
$buttonWifi.Add_Click({
    Start-Process "ms-settings:network-wifi"
    Log-Action "Opened Wi-Fi Settings page." "Wi-Fi Settings"
})
$stackPanel.Children.Add($buttonWifi)

# Ethernet Settings button
$buttonEthernet = New-Object System.Windows.Controls.Button
$buttonEthernet.Content = "Open Ethernet Settings"
$buttonEthernet.Width = 320
$buttonEthernet.Margin = [System.Windows.Thickness]::new(10)
$buttonEthernet.Add_Click({
    Start-Process "ms-settings:network-ethernet"
    Log-Action "Opened Ethernet Settings page." "Ethernet Settings"
})
$stackPanel.Children.Add($buttonEthernet)

# Network Troubleshooter button
$buttonTroubleshoot = New-Object System.Windows.Controls.Button
$buttonTroubleshoot.Content = "Open Network Troubleshooter"
$buttonTroubleshoot.Width = 320
$buttonTroubleshoot.Margin = [System.Windows.Thickness]::new(10)
$buttonTroubleshoot.Add_Click({
    Start-Process "ms-settings:troubleshoot"
    Log-Action "Opened Network Troubleshooter." "Network Troubleshooter"
})
$stackPanel.Children.Add($buttonTroubleshoot)

# System Settings button
$buttonSettings = New-Object System.Windows.Controls.Button
$buttonSettings.Content = "Open System Settings"
$buttonSettings.Width = 320
$buttonSettings.Margin = [System.Windows.Thickness]::new(10)
$buttonSettings.Add_Click({
    Start-Process "ms-settings:"
    Log-Action "Opened System Settings page." "System Settings"
})
$stackPanel.Children.Add($buttonSettings)

# Device Manager button
$buttonDeviceManager = New-Object System.Windows.Controls.Button
$buttonDeviceManager.Content = "Open Device Manager"
$buttonDeviceManager.Width = 320
$buttonDeviceManager.Margin = [System.Windows.Thickness]::new(10)
$buttonDeviceManager.Add_Click({
    Start-Process "devmgmt.msc"
    Log-Action "Opened Device Manager." "Device Manager"
})
$stackPanel.Children.Add($buttonDeviceManager)

# Command Prompt button
$buttonCmd = New-Object System.Windows.Controls.Button
$buttonCmd.Content = "Open Command Prompt"
$buttonCmd.Width = 320
$buttonCmd.Margin = [System.Windows.Thickness]::new(10)
$buttonCmd.Add_Click({
    Start-Process "cmd.exe"
    Log-Action "Opened Command Prompt for troubleshooting." "Command Prompt"
})
$stackPanel.Children.Add($buttonCmd)

# Event Viewer button
$buttonEventViewer = New-Object System.Windows.Controls.Button
$buttonEventViewer.Content = "Open Event Viewer"
$buttonEventViewer.Width = 320
$buttonEventViewer.Margin = [System.Windows.Thickness]::new(10)
$buttonEventViewer.Add_Click({
    Start-Process "eventvwr.msc"
    Log-Action "Opened Event Viewer." "Event Viewer"
})
$stackPanel.Children.Add($buttonEventViewer)

# Footer
$textBlockFooter = New-Object System.Windows.Controls.TextBlock
$textBlockFooter.Text = "Allester Padovani, Senior IT Specialist. All rights reserved."
$textBlockFooter.FontSize = 12
$textBlockFooter.FontStyle = [System.Windows.FontStyles]::Italic
$textBlockFooter.Foreground = [System.Windows.Media.Brushes]::Black
$textBlockFooter.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$textBlockFooter.Margin = [System.Windows.Thickness]::new(0, 20, 0, 5)
$stackPanel.Children.Add($textBlockFooter)

# Show the window
$window.ShowDialog()
