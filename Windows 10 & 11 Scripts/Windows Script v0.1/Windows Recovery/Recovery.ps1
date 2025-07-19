<#
.SYNOPSIS
    A script with a simple GUI to open Windows 11 recovery options.

.DESCRIPTION
    This script uses WPF (Windows Presentation Foundation) to create a user-friendly interface 
    that allows the user to access different recovery options on Windows 11.
    It also logs the actions to the Windows Event Log for auditing purposes.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-18
    Version     : 1.0
#>

# Enforce best practices: strict mode and proper error handling
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Add the necessary .NET assemblies for working with WPF (Windows Presentation Foundation) and system dialogs
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

# Function to log actions to the Event Log for auditing purposes
function Log-Action {
    param (
        [string]$message
    )

    $logName  = "Application"
    $source   = "PowerShell - Recovery Script"

    # Check if the event source exists, if not, create it (requires elevated rights)
    if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
        try {
            New-EventLog -LogName $logName -Source $source
        } catch {
            Write-Warning "Unable to create Event Log source. You may need to run the script as Administrator."
        }
    }

    Write-EventLog -LogName $logName -Source $source -EntryType Information -EventId 1000 -Message $message
}

# Create the main WPF window
$window = New-Object System.Windows.Window
$window.Title = "Windows Recovery Options"
$window.SizeToContent = 'WidthAndHeight'
$window.ResizeMode = [System.Windows.ResizeMode]::NoResize
$window.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterScreen

# Create the StackPanel to organize elements
$stackPanel = New-Object System.Windows.Controls.StackPanel
$stackPanel.Orientation = [System.Windows.Controls.Orientation]::Vertical
$stackPanel.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$stackPanel.VerticalAlignment = [System.Windows.VerticalAlignment]::Center
$window.Content = $stackPanel

# Header TextBlock
$textBlockHeader = New-Object System.Windows.Controls.TextBlock
$textBlockHeader.Text = "Recovery Options"
$textBlockHeader.FontSize = 14
$textBlockHeader.FontWeight = [System.Windows.FontWeights]::Bold
$textBlockHeader.TextAlignment = [System.Windows.TextAlignment]::Center
$textBlockHeader.Margin = [System.Windows.Thickness]::new(0, 0, 0, 20)
$stackPanel.Children.Add($textBlockHeader)

# Create StackPanel for buttons
$buttonPanel = New-Object System.Windows.Controls.StackPanel
$buttonPanel.Orientation = [System.Windows.Controls.Orientation]::Vertical
$buttonPanel.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$stackPanel.Children.Add($buttonPanel)

# Button to open 'Recovery' settings
$buttonRecoverySettings = New-Object System.Windows.Controls.Button
$buttonRecoverySettings.Content = "Open 'Recovery' Settings"
$buttonRecoverySettings.Width = 320
$buttonRecoverySettings.Margin = [System.Windows.Thickness]::new(10)
$buttonRecoverySettings.Add_Click({
    Start-Process "ms-settings:recovery"  # Launch Recovery settings page
    Log-Action "Opened 'Recovery' settings via PowerShell script."
})

# Button to open 'System Restore' options
$buttonSystemRestore = New-Object System.Windows.Controls.Button
$buttonSystemRestore.Content = "Open System Restore"
$buttonSystemRestore.Width = 320
$buttonSystemRestore.Margin = [System.Windows.Thickness]::new(10)
$buttonSystemRestore.Add_Click({
    Start-Process "rstrui.exe"  # Launch System Restore tool
    Log-Action "Opened System Restore via PowerShell script."
})

# Add buttons to the panel
$buttonPanel.Children.Add($buttonRecoverySettings)
$buttonPanel.Children.Add($buttonSystemRestore)

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
