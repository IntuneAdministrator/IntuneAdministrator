<#
.SYNOPSIS
    A comprehensive script that provides an interactive WPF GUI to manage system utilities, device manager, command prompt, event viewer, and more.

.DESCRIPTION
    This script utilizes WPF (Windows Presentation Foundation) to create a user-friendly interface for accessing common system utilities on Windows 11 24H2.
    The user can open the System Settings, Device Manager, Command Prompt, Event Viewer, and other utilities through a clean and intuitive GUI.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-18
    Version     : 1.0

.NOTES
    Compatibility: Windows 11 24H2 or later.
    Requires: PowerShell 5.1 or later, administrative rights for some actions (e.g., Event Log creation).
#>

# Enforce best practices: strict mode and proper error handling
Set-StrictMode -Version Latest  # Enforces best practices by ensuring variables are initialized before use
$ErrorActionPreference = "Stop"  # Automatically halts the script on errors to prevent unexpected behavior

# Add the necessary .NET assemblies for working with WPF (Windows Presentation Foundation) and system dialogs
Add-Type -AssemblyName PresentationFramework  # Adds WPF functionality to the script, which is crucial for GUI elements
Add-Type -AssemblyName System.Windows.Forms  # Adds Windows Forms for UI elements like Message Boxes

# Function to log actions to the Event Log for auditing purposes
function Log-Action {
    param (
        [string]$message  # Message to be logged
    )

    # Event log details
    $logName  = "Application"  # Log location
    $source   = "PowerShell - System Utilities Script"  # Unique source for the logs

    # Check if the event source exists, if not, create it (this requires elevated rights)
    if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
        try {
            New-EventLog -LogName $logName -Source $source  # Creates a new source for logging
        } catch {
            Write-Warning "Unable to create Event Log source. You may need to run the script as Administrator."
        }
    }

    # Write the action to the Event Log
    Write-EventLog -LogName $logName `
                   -Source $source `
                   -EntryType Information `
                   -EventId 1000 `
                   -Message $message
}

# Create the main WPF window to hold the UI controls
$window = New-Object System.Windows.Window
$window.Title = "System Utilities Dashboard"  # Title of the window
$window.Width = 400  # Window width
$window.Height = 350  # Window height
$window.ResizeMode = [System.Windows.ResizeMode]::NoResize  # Disables resizing for a fixed window size
$window.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterScreen  # Center window on the screen

# Create a StackPanel to organize UI elements vertically within the window
$stackPanel = New-Object System.Windows.Controls.StackPanel
$stackPanel.Orientation = [System.Windows.Controls.Orientation]::Vertical
$stackPanel.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$stackPanel.VerticalAlignment = [System.Windows.VerticalAlignment]::Center
$window.Content = $stackPanel

# Create a TextBlock to display the header of the window
$textBlockHeader = New-Object System.Windows.Controls.TextBlock
$textBlockHeader.Text = "System Utilities Dashboard"  # Header for the UI
$textBlockHeader.FontSize = 14  # Font size for header
$textBlockHeader.FontWeight = [System.Windows.FontWeights]::Bold  # Bold font style for emphasis
$textBlockHeader.TextAlignment = [System.Windows.TextAlignment]::Center  # Center-align the text
$textBlockHeader.Margin = [System.Windows.Thickness]::new(0, 0, 0, 20)  # Add margin below the header
$stackPanel.Children.Add($textBlockHeader)  # Add the header to the StackPanel

# Create a StackPanel for the buttons (options) the user can interact with
$buttonPanel = New-Object System.Windows.Controls.StackPanel
$buttonPanel.Orientation = [System.Windows.Controls.Orientation]::Vertical
$buttonPanel.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$stackPanel.Children.Add($buttonPanel)  # Add button panel to StackPanel

# Define each button and its corresponding functionality

# Button for launching Windows Hello Setup (now the first button)
$buttonWindowsHello = New-Object System.Windows.Controls.Button
$buttonWindowsHello.Content = "Open Windows Hello Setup"  # Button text
$buttonWindowsHello.Width = 300
$buttonWindowsHello.Margin = [System.Windows.Thickness]::new(10)
$buttonWindowsHello.Add_Click({
    Start-Process "ms-settings:signinoptions-launchfaceenrollment"  # Launch Windows Hello setup
    Log-Action "Opened Windows Hello Setup via PowerShell script."
})

# Button for opening System Settings
$buttonSystemSettings = New-Object System.Windows.Controls.Button
$buttonSystemSettings.Content = "Open System Settings"  # Button text
$buttonSystemSettings.Width = 300
$buttonSystemSettings.Margin = [System.Windows.Thickness]::new(10)
$buttonSystemSettings.Add_Click({
    Start-Process "ms-settings:"  # Launch System Settings
    Log-Action "Opened System Settings via PowerShell script."
})

# Button for opening Device Manager
$buttonDeviceManager = New-Object System.Windows.Controls.Button
$buttonDeviceManager.Content = "Open Device Manager"  # Button text
$buttonDeviceManager.Width = 300
$buttonDeviceManager.Margin = [System.Windows.Thickness]::new(10)
$buttonDeviceManager.Add_Click({
    Start-Process "devmgmt.msc"  # Launch Device Manager
    Log-Action "Opened Device Manager via PowerShell script."
})

# Button for opening Command Prompt
$buttonCmd = New-Object System.Windows.Controls.Button
$buttonCmd.Content = "Open Command Prompt"  # Button text
$buttonCmd.Width = 300
$buttonCmd.Margin = [System.Windows.Thickness]::new(10)
$buttonCmd.Add_Click({
    Start-Process "cmd.exe"  # Launch Command Prompt
    Log-Action "Opened Command Prompt via PowerShell script."
})

# Button for opening Event Viewer
$buttonEventViewer = New-Object System.Windows.Controls.Button
$buttonEventViewer.Content = "Open Event Viewer"  # Button text
$buttonEventViewer.Width = 300
$buttonEventViewer.Margin = [System.Windows.Thickness]::new(10)
$buttonEventViewer.Add_Click({
    Start-Process "eventvwr.msc"  # Launch Event Viewer
    Log-Action "Opened Event Viewer via PowerShell script."
})

# Add buttons to the button panel
$buttonPanel.Children.Add($buttonWindowsHello)  # Windows Hello button comes first
$buttonPanel.Children.Add($buttonSystemSettings)
$buttonPanel.Children.Add($buttonDeviceManager)
$buttonPanel.Children.Add($buttonCmd)
$buttonPanel.Children.Add($buttonEventViewer)

# === LAYOUT ADJUSTMENTS ONLY ===
# Set all buttons to width 320 as requested
$buttonWindowsHello.Width = 320
$buttonSystemSettings.Width = 320
$buttonDeviceManager.Width = 320
$buttonCmd.Width = 320
$buttonEventViewer.Width = 320

# Let window size itself automatically based on the content
$window.SizeToContent = 'WidthAndHeight'

# Footer TextBlock (with copyright and author info)
$textBlockFooter = New-Object System.Windows.Controls.TextBlock
$textBlockFooter.Text = "Allester Padovani, Senior IT Specialist. All rights reserved."  # Footer message
$textBlockFooter.FontSize = 12  # Font size
$textBlockFooter.FontStyle = [System.Windows.FontStyles]::Italic  # Italicize footer text
$textBlockFooter.Foreground = [System.Windows.Media.Brushes]::Black  # Set text color to black
$textBlockFooter.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center  # Center-align footer
$textBlockFooter.Margin = [System.Windows.Thickness]::new(0, 20, 0, 5)  # Add margin at the bottom
$stackPanel.Children.Add($textBlockFooter)  # Add footer to the StackPanel

# Display the WPF window and wait for user interaction
$window.ShowDialog()  # Show the window and allow user interaction
