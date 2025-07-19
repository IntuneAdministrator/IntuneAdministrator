<#
.SYNOPSIS
    A comprehensive script that provides an interactive WPF GUI to manage audio-related settings and system utilities.
    Includes options to access Startup Apps, System Settings, Device Manager, Command Prompt, and Event Viewer.

.DESCRIPTION
    The script utilizes WPF (Windows Presentation Foundation) to create a user-friendly interface for accessing common audio and system utilities on Windows 11 24H2.
    The user can open various sound settings, manage startup apps, and access system tools through an easy-to-navigate GUI.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-19
    Version     : 1.0

.NOTES
    Compatibility: Windows 11 24H2 or later.
    Requires: PowerShell 5.1 or later, administrative rights for some actions (e.g., Event Log creation).
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

function Log-Action {
    param (
        [string]$message
    )

    $logName = "Application"
    $source = "PowerShell - Audio Management Script"

    if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
        try {
            New-EventLog -LogName $logName -Source $source
        } catch {
            Write-Warning "Unable to create Event Log source. Run as Administrator if needed."
        }
    }

    Write-EventLog -LogName $logName `
                   -Source $source `
                   -EntryType Information `
                   -EventId 1000 `
                   -Message $message
}

# Create main window
$window = New-Object System.Windows.Window
$window.Title = "Audio Management Dashboard"
$window.SizeToContent = 'WidthAndHeight'
$window.ResizeMode = [System.Windows.ResizeMode]::NoResize
$window.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterScreen

# StackPanel container
$stackPanel = New-Object System.Windows.Controls.StackPanel
$stackPanel.Orientation = [System.Windows.Controls.Orientation]::Vertical
$stackPanel.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$stackPanel.VerticalAlignment = [System.Windows.VerticalAlignment]::Center
$window.Content = $stackPanel

# Header
$textBlockHeader = New-Object System.Windows.Controls.TextBlock
$textBlockHeader.Text = "Audio Management Dashboard"
$textBlockHeader.FontSize = 14
$textBlockHeader.FontWeight = [System.Windows.FontWeights]::Bold
$textBlockHeader.TextAlignment = [System.Windows.TextAlignment]::Center
$textBlockHeader.Margin = [System.Windows.Thickness]::new(0, 0, 0, 20)
$stackPanel.Children.Add($textBlockHeader)

# Buttons panel
$buttonPanel = New-Object System.Windows.Controls.StackPanel
$buttonPanel.Orientation = [System.Windows.Controls.Orientation]::Vertical
$buttonPanel.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$stackPanel.Children.Add($buttonPanel)

# Button: Open Startup Apps Settings
$btnStartupApps = New-Object System.Windows.Controls.Button
$btnStartupApps.Content = "Open 'Startup Apps' Settings"
$btnStartupApps.Width = 320
$btnStartupApps.Margin = [System.Windows.Thickness]::new(10)
$btnStartupApps.Add_Click({
    Start-Process "ms-settings:startupapps"
    Log-Action "Opened 'Startup Apps' settings via PowerShell script."
})
$buttonPanel.Children.Add($btnStartupApps)

# Button: Open System Settings
$btnSystemSettings = New-Object System.Windows.Controls.Button
$btnSystemSettings.Content = "Open System Settings"
$btnSystemSettings.Width = 320
$btnSystemSettings.Margin = [System.Windows.Thickness]::new(10)
$btnSystemSettings.Add_Click({
    Start-Process "ms-settings:"
    Log-Action "Opened System Settings via PowerShell script."
})
$buttonPanel.Children.Add($btnSystemSettings)

# Button: Open Device Manager
$btnDeviceManager = New-Object System.Windows.Controls.Button
$btnDeviceManager.Content = "Open Device Manager"
$btnDeviceManager.Width = 320
$btnDeviceManager.Margin = [System.Windows.Thickness]::new(10)
$btnDeviceManager.Add_Click({
    Start-Process "devmgmt.msc"
    Log-Action "Opened Device Manager via PowerShell script."
})
$buttonPanel.Children.Add($btnDeviceManager)

# Button: Open Command Prompt
$btnCmd = New-Object System.Windows.Controls.Button
$btnCmd.Content = "Open Command Prompt"
$btnCmd.Width = 320
$btnCmd.Margin = [System.Windows.Thickness]::new(10)
$btnCmd.Add_Click({
    Start-Process "cmd.exe"
    Log-Action "Opened Command Prompt via PowerShell script."
})
$buttonPanel.Children.Add($btnCmd)

# Button: Open Event Viewer
$btnEventViewer = New-Object System.Windows.Controls.Button
$btnEventViewer.Content = "Open Event Viewer"
$btnEventViewer.Width = 320
$btnEventViewer.Margin = [System.Windows.Thickness]::new(10)
$btnEventViewer.Add_Click({
    Start-Process "eventvwr.msc"
    Log-Action "Opened Event Viewer via PowerShell script."
})
$buttonPanel.Children.Add($btnEventViewer)

# Footer text block
$textBlockFooter = New-Object System.Windows.Controls.TextBlock
$textBlockFooter.Text = "Allester Padovani, Senior IT Specialist. All rights reserved."
$textBlockFooter.FontSize = 12
$textBlockFooter.FontStyle = [System.Windows.FontStyles]::Italic
$textBlockFooter.Foreground = [System.Windows.Media.Brushes]::Black
$textBlockFooter.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$textBlockFooter.Margin = [System.Windows.Thickness]::new(0, 20, 0, 5)
$stackPanel.Children.Add($textBlockFooter)

# Show the window and wait for interaction
$window.ShowDialog()
