<#
.SYNOPSIS
    A comprehensive script that provides an interactive WPF GUI to manage connected devices settings.

.DESCRIPTION
    This PowerShell script uses WPF to present a clean interface allowing quick access to Bluetooth,
    printers, USB settings, Device Manager, and other connected device tools. Logs each action to the event log.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-16
    Version     : 1.0

.NOTES
    Compatibility: Windows 11 24H2 or later.
    Requires: PowerShell 5.1+, .NET, and optionally administrative privileges for event log creation.
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Load WPF and Windows Forms assemblies
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

# Function to log user actions to Event Log
function Log-Action {
    param ([string]$message)
    $logName = "Application"
    $source  = "PowerShell - Connected Devices"

    if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
        try {
            New-EventLog -LogName $logName -Source $source
        } catch {
            Write-Warning "Could not register Event Log source. Try running as Administrator."
        }
    }

    try {
        Write-EventLog -LogName $logName -Source $source -EntryType Information -EventId 1001 -Message $message
    } catch {
        Write-Warning "Event log write failed: $_"
    }
}

# Create main window
$window = New-Object System.Windows.Window
$window.Title = "Connected Devices Dashboard"
$window.SizeToContent = 'WidthAndHeight'
$window.ResizeMode = 'NoResize'
$window.WindowStartupLocation = 'CenterScreen'

# Stack panel container
$stackPanel = New-Object System.Windows.Controls.StackPanel
$stackPanel.Orientation = 'Vertical'
$stackPanel.HorizontalAlignment = 'Center'
$stackPanel.VerticalAlignment = 'Center'
$window.Content = $stackPanel

# Header
$header = New-Object System.Windows.Controls.TextBlock
$header.Text = "Connected Devices Management"
$header.FontSize = 14
$header.FontWeight = 'Bold'
$header.TextAlignment = 'Center'
$header.Margin = [System.Windows.Thickness]::new(0, 0, 0, 20)
$stackPanel.Children.Add($header)

# Button panel
$buttonPanel = New-Object System.Windows.Controls.StackPanel
$buttonPanel.Orientation = 'Vertical'
$buttonPanel.HorizontalAlignment = 'Center'
$stackPanel.Children.Add($buttonPanel)

# Button Generator
function Add-DeviceButton {
    param (
        [string]$Label,
        [scriptblock]$Action
    )
    $btn = New-Object System.Windows.Controls.Button
    $btn.Content = $Label
    $btn.Width = 320
    $btn.Margin = [System.Windows.Thickness]::new(10)
    $btn.Add_Click($Action)
    $buttonPanel.Children.Add($btn)
}

# Buttons for various Connected Device settings
Add-DeviceButton "Connected Devices Overview" {
    Start-Process "ms-settings:connecteddevices"
    Log-Action "Opened Connected Devices Overview"
}

Add-DeviceButton "Bluetooth Devices" {
    Start-Process "ms-settings:bluetooth"
    Log-Action "Opened Bluetooth Settings"
}

Add-DeviceButton "Printers & Scanners" {
    Start-Process "ms-settings:printers"
    Log-Action "Opened Printers & Scanners"
}

Add-DeviceButton "USB Settings" {
    Start-Process "ms-settings:usb"
    Log-Action "Opened USB Settings"
}

Add-DeviceButton "Device Manager" {
    Start-Process "devmgmt.msc"
    Log-Action "Opened Device Manager"
}

# Footer
$footer = New-Object System.Windows.Controls.TextBlock
$footer.Text = "Allester Padovani, Senior IT Specialist. All rights reserved."
$footer.FontSize = 12
$footer.FontStyle = 'Italic'
$footer.Foreground = [System.Windows.Media.Brushes]::Black
$footer.HorizontalAlignment = 'Center'
$footer.Margin = [System.Windows.Thickness]::new(0, 20, 0, 5)
$stackPanel.Children.Add($footer)

# Show GUI
$window.ShowDialog()
