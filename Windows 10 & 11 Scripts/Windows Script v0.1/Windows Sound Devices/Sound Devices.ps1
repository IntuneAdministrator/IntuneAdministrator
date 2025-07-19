<#
.SYNOPSIS
    A comprehensive script that provides an interactive WPF GUI to manage audio and system utilities.
    Includes options to access audio settings, device manager, command prompt, event viewer, and more.

.DESCRIPTION
    The script utilizes WPF (Windows Presentation Foundation) to create a user-friendly interface for accessing common audio and system utilities on Windows 11 24H2.
    The user can open the "Sound Devices" settings, manage devices, troubleshoot audio, and more through an easy-to-navigate GUI.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-19
    Version     : 1.0

.NOTES
    Compatibility: Windows 11 24H2 or later.
    Requires: PowerShell 5.1 or later, administrative rights for some actions (e.g., Event Log creation).
#>

# Enforce best practices: strict mode and proper error handling
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Add .NET assemblies needed for WPF and message boxes
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

# Function to log actions to the Event Log for auditing purposes
function Log-Action {
    param (
        [string]$message
    )

    $logName = "Application"
    $source = "PowerShell - Audio Management Script"

    if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
        try {
            New-EventLog -LogName $logName -Source $source
        }
        catch {
            Write-Warning "Unable to create Event Log source. Run PowerShell as administrator."
        }
    }

    Write-EventLog -LogName $logName -Source $source -EntryType Information -EventId 1000 -Message $message
}

# Create the main window
$window = New-Object System.Windows.Window
$window.Title = "Audio Management Dashboard"
$window.SizeToContent = 'WidthAndHeight'
$window.ResizeMode = [System.Windows.ResizeMode]::NoResize
$window.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterScreen

# Main StackPanel for vertical layout
$stackPanel = New-Object System.Windows.Controls.StackPanel
$stackPanel.Orientation = [System.Windows.Controls.Orientation]::Vertical
$stackPanel.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$stackPanel.VerticalAlignment = [System.Windows.VerticalAlignment]::Center
$window.Content = $stackPanel

# Header TextBlock
$textBlockHeader = New-Object System.Windows.Controls.TextBlock
$textBlockHeader.Text = "Audio Management Dashboard"
$textBlockHeader.FontSize = 14
$textBlockHeader.FontWeight = [System.Windows.FontWeights]::Bold
$textBlockHeader.TextAlignment = [System.Windows.TextAlignment]::Center
$textBlockHeader.Margin = [System.Windows.Thickness]::new(0, 0, 0, 20)
$stackPanel.Children.Add($textBlockHeader)

# Buttons container StackPanel
$buttonPanel = New-Object System.Windows.Controls.StackPanel
$buttonPanel.Orientation = [System.Windows.Controls.Orientation]::Vertical
$buttonPanel.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$stackPanel.Children.Add($buttonPanel)

# Button: Open Sound Devices Settings
$buttonSoundDevices = New-Object System.Windows.Controls.Button
$buttonSoundDevices.Content = "Open 'Sound Devices' Settings"
$buttonSoundDevices.Width = 320
$buttonSoundDevices.Margin = [System.Windows.Thickness]::new(10)
$buttonSoundDevices.Add_Click({
    Start-Process "ms-settings:sound-devices"
    Log-Action "Opened 'Sound Devices' settings via PowerShell script."
})

# Button: Open System Sound Settings (General Sound)
$buttonSystemSound = New-Object System.Windows.Controls.Button
$buttonSystemSound.Content = "Open System Sound Settings"
$buttonSystemSound.Width = 320
$buttonSystemSound.Margin = [System.Windows.Thickness]::new(10)
$buttonSystemSound.Add_Click({
    Start-Process "ms-settings:sound"
    Log-Action "Opened System Sound settings via PowerShell script."
})

# Button: Open Device Manager
$buttonDeviceManager = New-Object System.Windows.Controls.Button
$buttonDeviceManager.Content = "Open Device Manager"
$buttonDeviceManager.Width = 320
$buttonDeviceManager.Margin = [System.Windows.Thickness]::new(10)
$buttonDeviceManager.Add_Click({
    Start-Process "devmgmt.msc"
    Log-Action "Opened Device Manager via PowerShell script."
})

# Button: Open Command Prompt
$buttonCmd = New-Object System.Windows.Controls.Button
$buttonCmd.Content = "Open Command Prompt"
$buttonCmd.Width = 320
$buttonCmd.Margin = [System.Windows.Thickness]::new(10)
$buttonCmd.Add_Click({
    Start-Process "cmd.exe"
    Log-Action "Opened Command Prompt via PowerShell script."
})

# Button: Open Event Viewer
$buttonEventViewer = New-Object System.Windows.Controls.Button
$buttonEventViewer.Content = "Open Event Viewer"
$buttonEventViewer.Width = 320
$buttonEventViewer.Margin = [System.Windows.Thickness]::new(10)
$buttonEventViewer.Add_Click({
    Start-Process "eventvwr.msc"
    Log-Action "Opened Event Viewer via PowerShell script."
})

# Add buttons to panel
$buttonPanel.Children.Add($buttonSoundDevices)
$buttonPanel.Children.Add($buttonSystemSound)
$buttonPanel.Children.Add($buttonDeviceManager)
$buttonPanel.Children.Add($buttonCmd)
$buttonPanel.Children.Add($buttonEventViewer)

# Footer TextBlock
$textBlockFooter = New-Object System.Windows.Controls.TextBlock
$textBlockFooter.Text = "Allester Padovani, Senior IT Specialist. All rights reserved."
$textBlockFooter.FontSize = 12
$textBlockFooter.FontStyle = [System.Windows.FontStyles]::Italic
$textBlockFooter.Foreground = [System.Windows.Media.Brushes]::Black
$textBlockFooter.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$textBlockFooter.Margin = [System.Windows.Thickness]::new(0, 20, 0, 5)
$stackPanel.Children.Add($textBlockFooter)

# Show the window and wait for user interaction
$window.ShowDialog()
