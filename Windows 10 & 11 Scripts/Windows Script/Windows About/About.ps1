<#
.SYNOPSIS
    System Info & Related Utilities Dashboard for Windows 11 24H2.

.DESCRIPTION
    Provides a WPF GUI with individual buttons to collect/display system info and open related tools:
    - Show System Info (detailed)
    - Open Device Manager
    - Open System Settings
    - Open About (Windows About page)
    - Open System Properties (sysdm.cpl)
    - Open Command Prompt
    - Open Event Viewer

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-15
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
    param ([string]$message, [string]$source = "PowerShell - System Info Dashboard")

    $logName = "Application"
    if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
        try { New-EventLog -LogName $logName -Source $source } catch {}
    }

    Write-EventLog -LogName $logName -Source $source -EntryType Information -EventId 1000 -Message $message
}

function Show-SystemInfo {
    # Gather system info
    $deviceName = $env:COMPUTERNAME
    $cpu = (Get-CimInstance Win32_Processor | Select-Object -First 1).Name
    $ramBytes = (Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory
    $installedRAM = "{0:N2} GB" -f ($ramBytes / 1GB)
    $deviceID = (Get-CimInstance Win32_ComputerSystemProduct).UUID
    $productID = (Get-ItemProperty "HKLM:\Software\Microsoft\Windows NT\CurrentVersion").ProductId
    $systemType = (Get-CimInstance Win32_ComputerSystem).SystemType
    $storageBytes = (Get-CimInstance Win32_DiskDrive | Measure-Object -Property Size -Sum).Sum
    $totalStorage = "{0:N2} GB" -f ($storageBytes / 1GB)
    $gpuList = (Get-CimInstance Win32_VideoController | Select-Object -ExpandProperty Name) -join ", "

    $info = @"
Device Name     : $deviceName
Processor       : $cpu
Installed RAM   : $installedRAM
Device ID       : $deviceID
Product ID      : $productID
System Type     : $systemType
Total Storage   : $totalStorage
Graphics Card(s): $gpuList

Collected by    : Allester Padovani
Job Title       : Senior IT Specialist
Script Version  : 1.0
Date            : $(Get-Date -Format "yyyy-MM-dd HH:mm")
"@

    [System.Windows.Forms.MessageBox]::Show($info, "System Info - Windows 11 24H2", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
}

# Create WPF Window
$window = New-Object System.Windows.Window
$window.Title = "System Info & Related Utilities"
$window.ResizeMode = [System.Windows.ResizeMode]::NoResize
$window.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterScreen
$window.SizeToContent = 'WidthAndHeight'  # Let window size to fit content

# Main stack panel
$stackPanel = New-Object System.Windows.Controls.StackPanel
$stackPanel.Orientation = [System.Windows.Controls.Orientation]::Vertical
$stackPanel.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$stackPanel.VerticalAlignment = [System.Windows.VerticalAlignment]::Center
$window.Content = $stackPanel

# Header
$textBlockHeader = New-Object System.Windows.Controls.TextBlock
$textBlockHeader.Text = "System Info & Related Utilities Dashboard"
$textBlockHeader.FontSize = 16
$textBlockHeader.FontWeight = [System.Windows.FontWeights]::Bold
$textBlockHeader.TextAlignment = [System.Windows.TextAlignment]::Center
$textBlockHeader.Margin = [System.Windows.Thickness]::new(0, 0, 0, 20)
$stackPanel.Children.Add($textBlockHeader)

# Button width setting
$buttonWidth = 320

# Show System Info button
$buttonSystemInfo = New-Object System.Windows.Controls.Button
$buttonSystemInfo.Content = "Show Detailed System Info"
$buttonSystemInfo.Width = $buttonWidth
$buttonSystemInfo.Margin = [System.Windows.Thickness]::new(10)
$buttonSystemInfo.Add_Click({
    Show-SystemInfo
    Log-Action "Displayed detailed system info." "System Info Dashboard"
})
$stackPanel.Children.Add($buttonSystemInfo)

# Device Manager button
$buttonDeviceManager = New-Object System.Windows.Controls.Button
$buttonDeviceManager.Content = "Open Device Manager"
$buttonDeviceManager.Width = $buttonWidth
$buttonDeviceManager.Margin = [System.Windows.Thickness]::new(10)
$buttonDeviceManager.Add_Click({
    Start-Process "devmgmt.msc"
    Log-Action "Opened Device Manager." "System Info Dashboard"
})
$stackPanel.Children.Add($buttonDeviceManager)

# System Settings button
$buttonSystemSettings = New-Object System.Windows.Controls.Button
$buttonSystemSettings.Content = "Open System Settings"
$buttonSystemSettings.Width = $buttonWidth
$buttonSystemSettings.Margin = [System.Windows.Thickness]::new(10)
$buttonSystemSettings.Add_Click({
    Start-Process "ms-settings:"
    Log-Action "Opened System Settings." "System Info Dashboard"
})
$stackPanel.Children.Add($buttonSystemSettings)

# About Windows button
$buttonAboutWindows = New-Object System.Windows.Controls.Button
$buttonAboutWindows.Content = "Open Windows About Page"
$buttonAboutWindows.Width = $buttonWidth
$buttonAboutWindows.Margin = [System.Windows.Thickness]::new(10)
$buttonAboutWindows.Add_Click({
    Start-Process "ms-settings:about"
    Log-Action "Opened Windows About Page." "System Info Dashboard"
})
$stackPanel.Children.Add($buttonAboutWindows)

# System Properties button
$buttonSysProperties = New-Object System.Windows.Controls.Button
$buttonSysProperties.Content = "Open System Properties"
$buttonSysProperties.Width = $buttonWidth
$buttonSysProperties.Margin = [System.Windows.Thickness]::new(10)
$buttonSysProperties.Add_Click({
    Start-Process "sysdm.cpl"
    Log-Action "Opened System Properties." "System Info Dashboard"
})
$stackPanel.Children.Add($buttonSysProperties)

# Command Prompt button
$buttonCmd = New-Object System.Windows.Controls.Button
$buttonCmd.Content = "Open Command Prompt"
$buttonCmd.Width = $buttonWidth
$buttonCmd.Margin = [System.Windows.Thickness]::new(10)
$buttonCmd.Add_Click({
    Start-Process "cmd.exe"
    Log-Action "Opened Command Prompt." "System Info Dashboard"
})
$stackPanel.Children.Add($buttonCmd)

# Event Viewer button
$buttonEventViewer = New-Object System.Windows.Controls.Button
$buttonEventViewer.Content = "Open Event Viewer"
$buttonEventViewer.Width = $buttonWidth
$buttonEventViewer.Margin = [System.Windows.Thickness]::new(10)
$buttonEventViewer.Add_Click({
    Start-Process "eventvwr.msc"
    Log-Action "Opened Event Viewer." "System Info Dashboard"
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

# Show Window
$window.ShowDialog()
