<#
.SYNOPSIS
    A comprehensive script that provides an interactive WPF GUI to manage system utilities.
    Includes options to access Sync Your Settings, system settings, device manager, command prompt, event viewer,
    and Windows account related settings pages.

.DESCRIPTION
    The script utilizes WPF (Windows Presentation Foundation) to create a user-friendly interface for accessing common system utilities on Windows 11 24H2.
    The user can open the "Sync Your Settings" page, system settings, manage devices, and more through an easy-to-navigate GUI.

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
    $source = "PowerShell - System Utilities Script"

    if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
        try {
            New-EventLog -LogName $logName -Source $source
        }
        catch {
            Write-Warning "Unable to create Event Log source. You may need to run the script as Administrator."
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
$window.Title = "System Utilities Dashboard"

# Let window size itself based on content
$window.SizeToContent = 'WidthAndHeight'

$window.ResizeMode = [System.Windows.ResizeMode]::NoResize
$window.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterScreen

# Main StackPanel
$stackPanel = New-Object System.Windows.Controls.StackPanel
$stackPanel.Orientation = [System.Windows.Controls.Orientation]::Vertical
$stackPanel.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$stackPanel.VerticalAlignment = [System.Windows.VerticalAlignment]::Center
$window.Content = $stackPanel

# Header TextBlock
$textBlockHeader = New-Object System.Windows.Controls.TextBlock
$textBlockHeader.Text = "System Utilities Dashboard"
$textBlockHeader.FontSize = 16
$textBlockHeader.FontWeight = [System.Windows.FontWeights]::Bold
$textBlockHeader.TextAlignment = [System.Windows.TextAlignment]::Center
$textBlockHeader.Margin = [System.Windows.Thickness]::new(0, 0, 0, 20)
$stackPanel.Children.Add($textBlockHeader)

# Button panel
$buttonPanel = New-Object System.Windows.Controls.StackPanel
$buttonPanel.Orientation = [System.Windows.Controls.Orientation]::Vertical
$buttonPanel.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$stackPanel.Children.Add($buttonPanel)

# Button: Open 'Sync Your Settings'
$buttonSyncSettings = New-Object System.Windows.Controls.Button
$buttonSyncSettings.Content = "Open 'Sync Your Settings'"
$buttonSyncSettings.Width = 320
$buttonSyncSettings.Margin = [System.Windows.Thickness]::new(10)
$buttonSyncSettings.Add_Click({
    Start-Process "ms-settings:sync"
    Log-Action "Opened 'Sync Your Settings' via PowerShell GUI."
})
$buttonPanel.Children.Add($buttonSyncSettings)

# Button: Open 'Your Info'
$buttonYourInfo = New-Object System.Windows.Controls.Button
$buttonYourInfo.Content = "Open 'Your Info'"
$buttonYourInfo.Width = 320
$buttonYourInfo.Margin = [System.Windows.Thickness]::new(10)
$buttonYourInfo.Add_Click({
    Start-Process "ms-settings:yourinfo"
    Log-Action "Opened 'Your Info' via PowerShell GUI."
})
$buttonPanel.Children.Add($buttonYourInfo)

# Button: Open 'Email & Accounts'
$buttonEmailAccounts = New-Object System.Windows.Controls.Button
$buttonEmailAccounts.Content = "Open 'Email & Accounts'"
$buttonEmailAccounts.Width = 320
$buttonEmailAccounts.Margin = [System.Windows.Thickness]::new(10)
$buttonEmailAccounts.Add_Click({
    Start-Process "ms-settings:emailandaccounts"
    Log-Action "Opened 'Email & Accounts' via PowerShell GUI."
})
$buttonPanel.Children.Add($buttonEmailAccounts)

# Button: Open 'Access work or school'
$buttonWorkSchool = New-Object System.Windows.Controls.Button
$buttonWorkSchool.Content = "Open 'Access Work or School'"
$buttonWorkSchool.Width = 320
$buttonWorkSchool.Margin = [System.Windows.Thickness]::new(10)
$buttonWorkSchool.Add_Click({
    Start-Process "ms-settings:workplace"
    Log-Action "Opened 'Access Work or School' via PowerShell GUI."
})
$buttonPanel.Children.Add($buttonWorkSchool)

# Button: Open System Settings
$buttonSystemSettings = New-Object System.Windows.Controls.Button
$buttonSystemSettings.Content = "Open System Settings"
$buttonSystemSettings.Width = 320
$buttonSystemSettings.Margin = [System.Windows.Thickness]::new(10)
$buttonSystemSettings.Add_Click({
    Start-Process "ms-settings:"
    Log-Action "Opened System Settings via PowerShell GUI."
})
$buttonPanel.Children.Add($buttonSystemSettings)

# Button: Open Device Manager
$buttonDeviceManager = New-Object System.Windows.Controls.Button
$buttonDeviceManager.Content = "Open Device Manager"
$buttonDeviceManager.Width = 320
$buttonDeviceManager.Margin = [System.Windows.Thickness]::new(10)
$buttonDeviceManager.Add_Click({
    Start-Process "devmgmt.msc"
    Log-Action "Opened Device Manager via PowerShell GUI."
})
$buttonPanel.Children.Add($buttonDeviceManager)

# Button: Open Command Prompt
$buttonCmd = New-Object System.Windows.Controls.Button
$buttonCmd.Content = "Open Command Prompt"
$buttonCmd.Width = 320
$buttonCmd.Margin = [System.Windows.Thickness]::new(10)
$buttonCmd.Add_Click({
    Start-Process "cmd.exe"
    Log-Action "Opened Command Prompt via PowerShell GUI."
})
$buttonPanel.Children.Add($buttonCmd)

# Button: Open Event Viewer
$buttonEventViewer = New-Object System.Windows.Controls.Button
$buttonEventViewer.Content = "Open Event Viewer"
$buttonEventViewer.Width = 320
$buttonEventViewer.Margin = [System.Windows.Thickness]::new(10)
$buttonEventViewer.Add_Click({
    Start-Process "eventvwr.msc"
    Log-Action "Opened Event Viewer via PowerShell GUI."
})
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

# Show the window
$window.ShowDialog()
