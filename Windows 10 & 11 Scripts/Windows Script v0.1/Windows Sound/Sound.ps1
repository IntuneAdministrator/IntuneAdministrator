<#
.SYNOPSIS
    A PowerShell GUI to manage audio settings on Windows 11 24H2 using WPF.

.DESCRIPTION
    This script provides a user-friendly interface with buttons to launch common sound-related tools and settings,
    including system sound settings, app volume preferences, sound devices overview, and device manager access.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-19
    Version     : 1.0

.NOTES
    Compatibility: Windows 11 24H2 or later
    Requires: PowerShell 5.1+, admin rights for Event Log entry creation
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

function Log-Action {
    param (
        [string]$Message
    )
    $logName = "Application"
    $source = "PowerShell - Audio Management Script"

    if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
        try {
            New-EventLog -LogName $logName -Source $source
        } catch {
            Write-Warning "Unable to create Event Log source. Run PowerShell as Administrator."
        }
    }

    Write-EventLog -LogName $logName `
                   -Source $source `
                   -EntryType Information `
                   -EventId 1001 `
                   -Message $Message
}

# Create WPF window
$window = New-Object System.Windows.Window
$window.Title = "Audio Management Dashboard"
$window.SizeToContent = 'WidthAndHeight'
$window.ResizeMode = 'NoResize'
$window.WindowStartupLocation = 'CenterScreen'

$stackPanel = New-Object System.Windows.Controls.StackPanel
$stackPanel.Orientation = "Vertical"
$stackPanel.HorizontalAlignment = "Center"
$stackPanel.VerticalAlignment = "Center"
$window.Content = $stackPanel

# Header
$textHeader = New-Object System.Windows.Controls.TextBlock
$textHeader.Text = "Audio Management Dashboard"
$textHeader.FontSize = 14
$textHeader.FontWeight = 'Bold'
$textHeader.TextAlignment = 'Center'
$textHeader.Margin = [System.Windows.Thickness]::new(0, 0, 0, 20)
$stackPanel.Children.Add($textHeader)

# Button panel
$buttonPanel = New-Object System.Windows.Controls.StackPanel
$buttonPanel.Orientation = 'Vertical'
$buttonPanel.HorizontalAlignment = 'Center'
$stackPanel.Children.Add($buttonPanel)

# Button 1 - Open Sound Settings
$buttonSoundSettings = New-Object System.Windows.Controls.Button
$buttonSoundSettings.Content = "Open Sound Settings"
$buttonSoundSettings.Width = 320
$buttonSoundSettings.Margin = [System.Windows.Thickness]::new(10)
$buttonSoundSettings.Add_Click({
    try {
        Start-Process "ms-settings:sound"
        Log-Action "Opened Sound Settings"
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Failed to open Sound Settings: $($_.Exception.Message)", "Error", "OK", "Error")
    }
})
$buttonPanel.Children.Add($buttonSoundSettings)

# Button 2 - App Volume & Device Preferences
$buttonAppVolume = New-Object System.Windows.Controls.Button
$buttonAppVolume.Content = "App Volume & Device Preferences"
$buttonAppVolume.Width = 320
$buttonAppVolume.Margin = [System.Windows.Thickness]::new(10)
$buttonAppVolume.Add_Click({
    try {
        Start-Process "ms-settings:apps-volume"
        Log-Action "Opened App Volume & Device Preferences"
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Failed to open App Volume & Device Preferences: $($_.Exception.Message)", "Error", "OK", "Error")
    }
})
$buttonPanel.Children.Add($buttonAppVolume)

# Button 3 - Sound Devices Overview
$buttonDevicesOverview = New-Object System.Windows.Controls.Button
$buttonDevicesOverview.Content = "Sound Devices Overview"
$buttonDevicesOverview.Width = 320
$buttonDevicesOverview.Margin = [System.Windows.Thickness]::new(10)
$buttonDevicesOverview.Add_Click({
    try {
        Start-Process "ms-settings:sound-devices"
        Log-Action "Opened Sound Devices Overview"
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Failed to open Sound Devices Overview: $($_.Exception.Message)", "Error", "OK", "Error")
    }
})
$buttonPanel.Children.Add($buttonDevicesOverview)

# Button 4 - Device Manager
$buttonDeviceManager = New-Object System.Windows.Controls.Button
$buttonDeviceManager.Content = "Device Manager"
$buttonDeviceManager.Width = 320
$buttonDeviceManager.Margin = [System.Windows.Thickness]::new(10)
$buttonDeviceManager.Add_Click({
    try {
        Start-Process "devmgmt.msc"
        Log-Action "Opened Device Manager"
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Failed to open Device Manager: $($_.Exception.Message)", "Error", "OK", "Error")
    }
})
$buttonPanel.Children.Add($buttonDeviceManager)

# Footer
$textFooter = New-Object System.Windows.Controls.TextBlock
$textFooter.Text = "Allester Padovani, Senior IT Specialist. All rights reserved."
$textFooter.FontSize = 12
$textFooter.FontStyle = 'Italic'
$textFooter.Foreground = [System.Windows.Media.Brushes]::Black
$textFooter.HorizontalAlignment = 'Center'
$textFooter.Margin = [System.Windows.Thickness]::new(0, 20, 0, 5)
$stackPanel.Children.Add($textFooter)

# Show window
$window.ShowDialog()
