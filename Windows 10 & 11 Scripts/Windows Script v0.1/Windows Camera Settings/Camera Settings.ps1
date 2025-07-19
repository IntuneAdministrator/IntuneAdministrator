<#
.SYNOPSIS
    Launches all Camera-related settings for Windows 11 24H2 in a WPF-based GUI.

.DESCRIPTION
    Provides separate buttons for accessing Camera privacy, default app settings, and related features.
    Each action logs an event to the Windows Application event log.
    No confirmations or message boxes — direct and professional workflow.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-16
    Version     : 1.0

.NOTES
    Compatibility: Windows 11 24H2 and above
    Requires: Admin privileges for first-time event source creation
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Add-Type -AssemblyName PresentationFramework

function Log-Action {
    param([string]$message)

    $logName = "Application"
    $source = "PowerShell - Camera Launcher"

    if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
        try {
            New-EventLog -LogName $logName -Source $source
        } catch {
            Write-Warning "Could not create event log source. Run PowerShell as Administrator."
        }
    }

    Write-EventLog -LogName $logName -Source $source -EntryType Information -EventId 4000 -Message $message
}

# Create main window
$window = New-Object System.Windows.Window
$window.Title = "Camera Tools"
$window.ResizeMode = 'NoResize'
$window.WindowStartupLocation = 'CenterScreen'
$window.SizeToContent = 'WidthAndHeight'  # Auto-size window to fit content

# StackPanel layout
$panel = New-Object System.Windows.Controls.StackPanel
$panel.HorizontalAlignment = "Center"
$panel.VerticalAlignment = "Center"
$window.Content = $panel

# Header
$header = New-Object System.Windows.Controls.TextBlock
$header.Text = "Camera Settings Dashboard"
$header.FontSize = 16
$header.FontWeight = "Bold"
$header.TextAlignment = "Center"
$header.Margin = "0,0,0,20"
$panel.Children.Add($header)

# Button: Camera App Settings
$btnCameraApp = New-Object System.Windows.Controls.Button
$btnCameraApp.Content = "Open Camera App Settings"
$btnCameraApp.Width = 320
$btnCameraApp.Margin = [System.Windows.Thickness]::new(10)
$btnCameraApp.Add_Click({
    Start-Process "ms-settings:appsfeatures-app"
    Log-Action "Opened Camera App Settings"
})
$panel.Children.Add($btnCameraApp)

# Button: Camera Privacy Settings
$btnPrivacy = New-Object System.Windows.Controls.Button
$btnPrivacy.Content = "Privacy Settings for Camera"
$btnPrivacy.Width = 320
$btnPrivacy.Margin = [System.Windows.Thickness]::new(10)
$btnPrivacy.Add_Click({
    Start-Process "ms-settings:privacy-webcam"
    Log-Action "Opened Camera Privacy Settings"
})
$panel.Children.Add($btnPrivacy)

# Button: General Camera Settings Page
$btnCameraMain = New-Object System.Windows.Controls.Button
$btnCameraMain.Content = "Camera Device Settings"
$btnCameraMain.Width = 320
$btnCameraMain.Margin = [System.Windows.Thickness]::new(10)
$btnCameraMain.Add_Click({
    Start-Process "ms-settings:camera"
    Log-Action "Opened Camera Device Settings"
})
$panel.Children.Add($btnCameraMain)

# Button: Optional - Video Default App Settings
$btnVideoDefaults = New-Object System.Windows.Controls.Button
$btnVideoDefaults.Content = "Video Defaults (Camera App)"
$btnVideoDefaults.Width = 320
$btnVideoDefaults.Margin = [System.Windows.Thickness]::new(10)
$btnVideoDefaults.Add_Click({
    Start-Process "ms-settings:defaultapps"
    Log-Action "Opened Default App Settings for Video/Camera"
})
$panel.Children.Add($btnVideoDefaults)

# Footer
$footer = New-Object System.Windows.Controls.TextBlock
$footer.Text = "Allester Padovani – Senior IT Specialist"
$footer.FontSize = 12
$footer.FontStyle = [System.Windows.FontStyles]::Italic
$footer.Margin = "0,20,0,10"
$footer.HorizontalAlignment = "Center"
$panel.Children.Add($footer)

# Launch the GUI
$window.ShowDialog()
