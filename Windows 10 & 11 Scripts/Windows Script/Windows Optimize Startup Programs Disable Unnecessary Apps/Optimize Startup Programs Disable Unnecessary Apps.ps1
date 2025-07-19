<#
.SYNOPSIS
    A comprehensive script providing an interactive WPF GUI to manage system utilities on Windows 11 24H2, including Task Manager, System Settings, Device Manager, Command Prompt, and Event Viewer.

.DESCRIPTION
    This script leverages Windows Presentation Foundation (WPF) to create a professional and intuitive graphical user interface for accessing common system utilities. It uses event logging for auditing, making it suitable for enterprise environments.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-18
    Version     : 1.0

.NOTES
    Compatibility: Windows 11 24H2 or later
    Requires: PowerShell 5.1 or later
    Administrative rights required for Event Log creation
#>

# -- BEST PRACTICES --
# Enable strict mode to ensure variables are initialized before use, reducing the risk of errors
Set-StrictMode -Version Latest

# Stop the script on errors to prevent unexpected behavior and ensure error handling is done appropriately
$ErrorActionPreference = "Stop"

# -- Load Required Assemblies --
# Load .NET Assemblies required for WPF and Windows Forms functionalities
Add-Type -AssemblyName PresentationFramework  # WPF functionality for GUI
Add-Type -AssemblyName System.Windows.Forms    # Required for MessageBox (optional for troubleshooting)

# -- Log Action Function --
# This function logs actions to the Event Log for auditing purposes
function Log-Action {
    param (
        [string]$message,  # Message to be logged
        [int]$eventId,     # Event ID for the log
        [string]$source    # Source for the log entry
    )

    # Define the event log settings
    $logName  = "Application"  # Log name where events are written
    $source   = "PowerShell - System Utilities Script"  # Unique source for the log entry

    # Check if the event source exists; if not, create it
    if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
        try {
            # Create the event source (requires admin rights)
            New-EventLog -LogName $logName -Source $source
        } catch {
            # Handle errors in creating the event log source
            Write-Warning "Unable to create Event Log source. Please run the script with elevated privileges."
        }
    }

    # Write the action to the Event Log
    Write-EventLog -LogName $logName `
                   -Source $source `
                   -EntryType Information `
                   -EventId $eventId `
                   -Message $message
}

# -- Create Main Window for GUI --
# Create the WPF window object that will contain all GUI elements
$window = New-Object System.Windows.Window
$window.Title = "System Utilities Dashboard"  # Set the window title
$window.SizeToContent = 'WidthAndHeight'      # Let window size itself based on content
$window.ResizeMode = [System.Windows.ResizeMode]::NoResize  # Prevent resizing of the window
$window.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterScreen  # Center window on screen

# Create a StackPanel to arrange UI elements vertically inside the window
$stackPanel = New-Object System.Windows.Controls.StackPanel
$stackPanel.Orientation = [System.Windows.Controls.Orientation]::Vertical  # Stack buttons vertically
$stackPanel.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center  # Center horizontally
$stackPanel.VerticalAlignment = [System.Windows.VerticalAlignment]::Center  # Center vertically
$window.Content = $stackPanel  # Set the content of the window to be the StackPanel

# -- Create Header --
# Create a TextBlock for the window's header
$textBlockHeader = New-Object System.Windows.Controls.TextBlock
$textBlockHeader.Text = "System Utilities Dashboard"  # Header text
$textBlockHeader.FontSize = 14  # Set font size
$textBlockHeader.FontWeight = [System.Windows.FontWeights]::Bold  # Bold font for emphasis
$textBlockHeader.TextAlignment = [System.Windows.TextAlignment]::Center  # Center-align the text
$textBlockHeader.Margin = [System.Windows.Thickness]::new(0, 0, 0, 20)  # Add margin below the header
$stackPanel.Children.Add($textBlockHeader)  # Add header to the StackPanel

# -- Create Buttons for Utilities --
# Create a StackPanel to hold buttons for opening utilities
$buttonPanel = New-Object System.Windows.Controls.StackPanel
$buttonPanel.Orientation = [System.Windows.Controls.Orientation]::Vertical  # Stack buttons vertically
$buttonPanel.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center  # Center horizontally
$stackPanel.Children.Add($buttonPanel)  # Add button panel to StackPanel

# -- Create Utility Buttons --

# Button for Task Manager
$buttonTaskManager = New-Object System.Windows.Controls.Button
$buttonTaskManager.Content = "Open Task Manager"
$buttonTaskManager.Width = 320  # Set button width
$buttonTaskManager.Margin = [System.Windows.Thickness]::new(10)  # Set margin around the button
$buttonTaskManager.Add_Click({
    try {
        Start-Process "taskmgr.exe"  # Start Task Manager
        Log-Action "Opened Task Manager." 1007 "Task Manager"  # Log the action with correct EventId
    } catch {
        Write-Warning "Failed to open Task Manager: $_"
    }
})

# Button for System Settings
$buttonSystemSettings = New-Object System.Windows.Controls.Button
$buttonSystemSettings.Content = "Open System Settings"
$buttonSystemSettings.Width = 320
$buttonSystemSettings.Margin = [System.Windows.Thickness]::new(10)
$buttonSystemSettings.Add_Click({
    try {
        Start-Process "ms-settings:"  # Launch System Settings
        Log-Action "Opened System Settings page." 1002 "System Settings"  # Log the action with correct EventId
    } catch {
        Write-Warning "Failed to open System Settings: $_"
    }
})

# Button for Device Manager
$buttonDeviceManager = New-Object System.Windows.Controls.Button
$buttonDeviceManager.Content = "Open Device Manager"
$buttonDeviceManager.Width = 320
$buttonDeviceManager.Margin = [System.Windows.Thickness]::new(10)
$buttonDeviceManager.Add_Click({
    try {
        Start-Process "devmgmt.msc"  # Launch Device Manager
        Log-Action "Opened Device Manager." 1003 "Device Manager"  # Log the action with correct EventId
    } catch {
        Write-Warning "Failed to open Device Manager: $_"
    }
})

# Button for Command Prompt
$buttonCmd = New-Object System.Windows.Controls.Button
$buttonCmd.Content = "Open Command Prompt"
$buttonCmd.Width = 320
$buttonCmd.Margin = [System.Windows.Thickness]::new(10)
$buttonCmd.Add_Click({
    try {
        Start-Process "cmd.exe"  # Start Command Prompt
        Log-Action "Opened Command Prompt for troubleshooting." 1004 "Command Prompt"  # Log the action with correct EventId
    } catch {
        Write-Warning "Failed to open Command Prompt: $_"
    }
})

# Button for Event Viewer
$buttonEventViewer = New-Object System.Windows.Controls.Button
$buttonEventViewer.Content = "Open Event Viewer"
$buttonEventViewer.Width = 320
$buttonEventViewer.Margin = [System.Windows.Thickness]::new(10)
$buttonEventViewer.Add_Click({
    try {
        Start-Process "eventvwr.msc"  # Start Event Viewer
        Log-Action "Opened Event Viewer." 1005 "Event Viewer"  # Log the action with correct EventId
    } catch {
        Write-Warning "Failed to open Event Viewer: $_"
    }
})

# Add buttons to the button panel
$buttonPanel.Children.Add($buttonTaskManager)
$buttonPanel.Children.Add($buttonSystemSettings)
$buttonPanel.Children.Add($buttonDeviceManager)
$buttonPanel.Children.Add($buttonCmd)
$buttonPanel.Children.Add($buttonEventViewer)

# -- Footer Information --
# Create a footer TextBlock displaying author and copyright information
$textBlockFooter = New-Object System.Windows.Controls.TextBlock
$textBlockFooter.Text = "Allester Padovani, Senior IT Specialist. All rights reserved."
$textBlockFooter.FontSize = 12  # Set font size
$textBlockFooter.FontStyle = [System.Windows.FontStyles]::Italic  # Italicize footer text
$textBlockFooter.Foreground = [System.Windows.Media.Brushes]::Black  # Set text color
$textBlockFooter.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center  # Center-align footer text
$textBlockFooter.Margin = [System.Windows.Thickness]::new(0, 20, 0, 5)  # Add margin at the bottom
$stackPanel.Children.Add($textBlockFooter)  # Add footer to the StackPanel

# -- Show the Window --
# Show the WPF window and allow user interaction
$window.ShowDialog()
