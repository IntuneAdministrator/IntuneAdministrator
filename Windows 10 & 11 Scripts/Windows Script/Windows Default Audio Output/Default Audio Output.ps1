<#
.SYNOPSIS
    PowerShell WPF GUI for Windows 11 24H2 with Default Apps, Apps & Features, and Default Audio Output buttons.

.DESCRIPTION
    Provides a simple WPF GUI to open various Windows 11 settings pages.
    Includes action logging to Windows Application event log.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-16
    Version     : 1.0

.NOTES
    Compatibility: Windows 11 24H2 or later.
    Requires: PowerShell 5.1 or later, administrative rights for event log source creation.
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

function Log-Action {
    param (
        [string]$message
    )
    $logName = 'Application'
    $source = 'PowerShell - Apps Settings GUI'

    if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
        try {
            New-EventLog -LogName $logName -Source $source
        } catch {
            Write-Warning "Unable to create event log source. Run script as Administrator."
        }
    }

    Write-EventLog -LogName $logName -Source $source -EntryType Information -EventId 1000 -Message $message
}

# Create the WPF window
$window = New-Object System.Windows.Window
$window.Title = "Windows 11 Settings Launcher"
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
$header = New-Object System.Windows.Controls.TextBlock
$header.Text = "Windows 11 Settings Launcher"
$header.FontSize = 16
$header.FontWeight = [System.Windows.FontWeights]::Bold
$header.TextAlignment = [System.Windows.TextAlignment]::Center
$header.Margin = [System.Windows.Thickness]::new(0, 0, 0, 20)
$stackPanel.Children.Add($header)

# Button: Default Apps
$btnDefaultApps = New-Object System.Windows.Controls.Button
$btnDefaultApps.Content = "Open Default Apps"
$btnDefaultApps.Width = 320
$btnDefaultApps.Margin = [System.Windows.Thickness]::new(10)
$btnDefaultApps.Add_Click({
    Start-Process "ms-settings:defaultapps"
    Log-Action "User opened Default Apps settings."
})
$stackPanel.Children.Add($btnDefaultApps)

# Button: Apps & Features
$btnAppsFeatures = New-Object System.Windows.Controls.Button
$btnAppsFeatures.Content = "Open Apps & Features"
$btnAppsFeatures.Width = 320
$btnAppsFeatures.Margin = [System.Windows.Thickness]::new(10)
$btnAppsFeatures.Add_Click({
    Start-Process "ms-settings:appsfeatures"
    Log-Action "User opened Apps & Features settings."
})
$stackPanel.Children.Add($btnAppsFeatures)

# Button: Default Audio Output
$btnDefaultAudio = New-Object System.Windows.Controls.Button
$btnDefaultAudio.Content = "Open Default Audio Output"
$btnDefaultAudio.Width = 320
$btnDefaultAudio.Margin = [System.Windows.Thickness]::new(10)
$btnDefaultAudio.Add_Click({
    Start-Process "ms-settings:sound-defaultoutputproperties"
    Log-Action "User opened Default Audio Output settings."
})
$stackPanel.Children.Add($btnDefaultAudio)

# Footer TextBlock
$footer = New-Object System.Windows.Controls.TextBlock
$footer.Text = "Allester Padovani, Senior IT Specialist. All rights reserved."
$footer.FontSize = 12
$footer.FontStyle = [System.Windows.FontStyles]::Italic
$footer.Foreground = [System.Windows.Media.Brushes]::Black
$footer.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$footer.Margin = [System.Windows.Thickness]::new(0, 20, 0, 5)
$stackPanel.Children.Add($footer)

# Show the window and wait for interaction
$window.ShowDialog()
