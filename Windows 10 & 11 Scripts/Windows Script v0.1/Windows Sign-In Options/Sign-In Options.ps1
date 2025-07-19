<#
.SYNOPSIS
    A GUI script for managing Sign-In Options in Windows 11.
    The script allows the user to open specific settings related to sign-in options such as Work or School accounts.

.DESCRIPTION
    This script creates a WPF (Windows Presentation Foundation) window with buttons that allow the user to open different settings related to Sign-In Options.
    The script uses [System.Windows] to create the UI and integrates several common Sign-In options available in Windows 11 24H2.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-19
    Version     : 1.0

.NOTES
    Compatibility: Windows 11 24H2 or later.
    Requires: PowerShell 5.1 or later, administrative rights for some actions.
#>

# Enforce best practices: strict mode and error handling
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Add necessary .NET assemblies for working with WPF and Forms
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

# Create the main WPF window
$window = New-Object System.Windows.Window
$window.Title = "Sign-In Options Management"
$window.SizeToContent = 'WidthAndHeight'
$window.ResizeMode = [System.Windows.ResizeMode]::NoResize
$window.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterScreen

# Create a StackPanel to hold the UI elements
$stackPanel = New-Object System.Windows.Controls.StackPanel
$stackPanel.Orientation = [System.Windows.Controls.Orientation]::Vertical
$stackPanel.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$stackPanel.VerticalAlignment = [System.Windows.VerticalAlignment]::Center
$window.Content = $stackPanel

# Create a header label for the window
$textBlockHeader = New-Object System.Windows.Controls.TextBlock
$textBlockHeader.Text = "Sign-In Options Management"
$textBlockHeader.FontSize = 14
$textBlockHeader.FontWeight = [System.Windows.FontWeights]::Bold
$textBlockHeader.TextAlignment = [System.Windows.TextAlignment]::Center
$textBlockHeader.Margin = [System.Windows.Thickness]::new(0, 0, 0, 20)
$stackPanel.Children.Add($textBlockHeader)

# Create a panel for buttons
$buttonPanel = New-Object System.Windows.Controls.StackPanel
$buttonPanel.Orientation = [System.Windows.Controls.Orientation]::Vertical
$buttonPanel.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$stackPanel.Children.Add($buttonPanel)

# Button to open PIN Setup
$buttonPIN = New-Object System.Windows.Controls.Button
$buttonPIN.Content = "Open PIN Setup"
$buttonPIN.Width = 320
$buttonPIN.Margin = [System.Windows.Thickness]::new(10)
$buttonPIN.Add_Click({
    Start-Process "ms-settings:signinoptions"  # Open Sign-In Options where PIN setup is located
    Log-Action "Opened PIN Setup Settings."
})

# Button to open Access Work or School account settings
$buttonWorkSchool = New-Object System.Windows.Controls.Button
$buttonWorkSchool.Content = "Open Work or School Account Settings"
$buttonWorkSchool.Width = 320
$buttonWorkSchool.Margin = [System.Windows.Thickness]::new(10)
$buttonWorkSchool.Add_Click({
    Start-Process "ms-settings:workplace"  # Open Work or School Account Settings
    Log-Action "Opened Work or School Account Settings."
})

# Add buttons to the panel
$buttonPanel.Children.Add($buttonPIN)
$buttonPanel.Children.Add($buttonWorkSchool)

# Function to log actions to the Event Log
function Log-Action {
    param (
        [string]$message
    )

    # Event Log details
    $logName = "Application"
    $source = "PowerShell - Sign-In Options Script"

    # Check if the event source exists, create it if not (requires elevated rights)
    if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
        try {
            New-EventLog -LogName $logName -Source $source
        } catch {
            Write-Warning "Unable to create Event Log source. You may need to run the script as Administrator."
        }
    }

    # Write the action to the Event Log
    Write-EventLog -LogName $logName -Source $source -EntryType Information -EventId 1000 -Message $message
}

# Footer TextBlock with author information
$textBlockFooter = New-Object System.Windows.Controls.TextBlock
$textBlockFooter.Text = "Allester Padovani, Senior IT Specialist. All rights reserved."
$textBlockFooter.FontSize = 12
$textBlockFooter.FontStyle = [System.Windows.FontStyles]::Italic
$textBlockFooter.Foreground = [System.Windows.Media.Brushes]::Black
$textBlockFooter.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$textBlockFooter.Margin = [System.Windows.Thickness]::new(0, 20, 0, 5)
$stackPanel.Children.Add($textBlockFooter)

# Display the window
$window.ShowDialog()
