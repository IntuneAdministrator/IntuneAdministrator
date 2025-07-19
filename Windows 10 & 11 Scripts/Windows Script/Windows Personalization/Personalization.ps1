<#
.SYNOPSIS
    A comprehensive script that provides an interactive WPF GUI to manage system utilities and printers.
    Includes options to access system settings, device manager, command prompt, event viewer, and personalization settings.

.DESCRIPTION
    The script utilizes WPF (Windows Presentation Foundation) to create a user-friendly interface for accessing common system utilities on Windows 11 24H2.
    The user can open "Personalization" settings, "System Settings", manage devices, troubleshoot printers, and more.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-18
    Version     : 1.0

.NOTES
    Compatibility: Windows 11 24H2 or later.
    Requires: PowerShell 5.1 or later, administrative rights for some actions (e.g., Event Log creation).
#>

# -- Enforce Best Practices --
Set-StrictMode -Version Latest  # Enforces strict mode to ensure variables are initialized before use.
$ErrorActionPreference = "Stop"  # Automatically halts the script on errors to prevent unexpected behavior.

# -- Add Necessary .NET Assemblies --
Add-Type -AssemblyName PresentationFramework  # Adds WPF functionality to the script.
Add-Type -AssemblyName System.Windows.Forms  # Adds Windows Forms functionality (MessageBox support).

# -- Function to Log Actions --
function Log-Action {
    param (
        [string]$message  # Message to log
    )

    # Log configuration
    $logName  = "Application"  # Event log name.
    $source   = "PowerShell - System Utility Dashboard"  # Source for the event logs.

    # Check if the event source exists, create it if it doesn't.
    if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
        try {
            New-EventLog -LogName $logName -Source $source  # Create the source if it doesn't exist.
        } catch {
            Write-Warning "Unable to create Event Log source. You may need to run the script as Administrator."
        }
    }

    # Write the log entry to the event log.
    Write-EventLog -LogName $logName -Source $source -EntryType Information -EventId 1000 -Message $message
}

# -- Create Main WPF Window --
$window = New-Object System.Windows.Window
$window.Title = "System Utilities Dashboard"  # Window title.
$window.SizeToContent = 'WidthAndHeight'       # Let window size itself based on content
$window.ResizeMode = [System.Windows.ResizeMode]::NoResize  # Disable resizing for a fixed window.
$window.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterScreen  # Center the window on screen.

# -- Create Main StackPanel to Organize UI --
$stackPanel = New-Object System.Windows.Controls.StackPanel
$stackPanel.Orientation = [System.Windows.Controls.Orientation]::Vertical  # Stack UI elements vertically.
$stackPanel.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center  # Center the panel horizontally.
$stackPanel.VerticalAlignment = [System.Windows.VerticalAlignment]::Center  # Center the panel vertically.
$window.Content = $stackPanel  # Set the StackPanel as the content of the window.

# -- Add Header TextBlock --
$textBlockHeader = New-Object System.Windows.Controls.TextBlock
$textBlockHeader.Text = "System Utilities Dashboard"  # Header text.
$textBlockHeader.FontSize = 14  # Font size for header.
$textBlockHeader.FontWeight = [System.Windows.FontWeights]::Bold  # Bold the header text.
$textBlockHeader.TextAlignment = [System.Windows.TextAlignment]::Center  # Center-align the header text.
$textBlockHeader.Margin = [System.Windows.Thickness]::new(0, 0, 0, 20)  # Add margin below the header.
$stackPanel.Children.Add($textBlockHeader)  # Add the header to the panel.

# -- Create Button Panel --
$buttonPanel = New-Object System.Windows.Controls.StackPanel
$buttonPanel.Orientation = [System.Windows.Controls.Orientation]::Vertical  # Stack buttons vertically.
$buttonPanel.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center  # Center buttons horizontally.
$stackPanel.Children.Add($buttonPanel)  # Add the button panel to the stack.

# -- Define Buttons and Their Actions --

# Button for opening Personalization Settings
$buttonPersonalization = New-Object System.Windows.Controls.Button
$buttonPersonalization.Content = "Open Personalization Settings"
$buttonPersonalization.Width = 320
$buttonPersonalization.Margin = [System.Windows.Thickness]::new(10)
$buttonPersonalization.Add_Click({
    Start-Process "ms-settings:personalization"  # Open Personalization settings.
    Log-Action "Opened Personalization settings via PowerShell script."
})

# Button for opening System Settings
$buttonSettings = New-Object System.Windows.Controls.Button
$buttonSettings.Content = "Open System Settings"
$buttonSettings.Width = 320
$buttonSettings.Margin = [System.Windows.Thickness]::new(10)
$buttonSettings.Add_Click({
    Start-Process "ms-settings:"  # Open System Settings.
    Log-Action "Opened System Settings via PowerShell script."
})

# Button for opening Device Manager
$buttonDeviceManager = New-Object System.Windows.Controls.Button
$buttonDeviceManager.Content = "Open Device Manager"
$buttonDeviceManager.Width = 320
$buttonDeviceManager.Margin = [System.Windows.Thickness]::new(10)
$buttonDeviceManager.Add_Click({
    Start-Process "devmgmt.msc"  # Open Device Manager.
    Log-Action "Opened Device Manager via PowerShell script."
})

# Button for opening Command Prompt
$buttonCmd = New-Object System.Windows.Controls.Button
$buttonCmd.Content = "Open Command Prompt"
$buttonCmd.Width = 320
$buttonCmd.Margin = [System.Windows.Thickness]::new(10)
$buttonCmd.Add_Click({
    Start-Process "cmd.exe"  # Open Command Prompt.
    Log-Action "Opened Command Prompt via PowerShell script."
})

# Button for opening Event Viewer
$buttonEventViewer = New-Object System.Windows.Controls.Button
$buttonEventViewer.Content = "Open Event Viewer"
$buttonEventViewer.Width = 320
$buttonEventViewer.Margin = [System.Windows.Thickness]::new(10)
$buttonEventViewer.Add_Click({
    Start-Process "eventvwr.msc"  # Open Event Viewer.
    Log-Action "Opened Event Viewer via PowerShell script."
})

# -- Add Buttons to the Button Panel --
$buttonPanel.Children.Add($buttonPersonalization)
$buttonPanel.Children.Add($buttonSettings)
$buttonPanel.Children.Add($buttonDeviceManager)
$buttonPanel.Children.Add($buttonCmd)
$buttonPanel.Children.Add($buttonEventViewer)

# -- Footer TextBlock (with author and copyright information) --
$textBlockFooter = New-Object System.Windows.Controls.TextBlock
$textBlockFooter.Text = "Allester Padovani, Senior IT Specialist. All rights reserved."
$textBlockFooter.FontSize = 12  # Font size for footer text.
$textBlockFooter.FontStyle = [System.Windows.FontStyles]::Italic  # Italicize footer text.
$textBlockFooter.Foreground = [System.Windows.Media.Brushes]::Black  # Set footer text color to black.
$textBlockFooter.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center  # Center-align footer text.
$textBlockFooter.Margin = [System.Windows.Thickness]::new(0, 20, 0, 5)  # Add margin at the bottom of the footer.
$stackPanel.Children.Add($textBlockFooter)  # Add footer to the stack panel.

# -- Display the WPF Window --
$window.ShowDialog()  # Display the window and wait for user interaction.
