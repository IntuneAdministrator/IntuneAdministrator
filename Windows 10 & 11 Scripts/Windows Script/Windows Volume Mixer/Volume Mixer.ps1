<#
.SYNOPSIS
    Windows Sound & Volume Mixer Management Dashboard with individual buttons for related settings on Windows 11 24H2.

.DESCRIPTION
    WPF GUI with buttons for sound & volume mixer related pages: Volume Mixer, Sound Settings, Microphone, App Volume & Device Preferences.
    Each button launches the respective ms-settings URI and logs the action.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-20
    Version     : 1.0

.NOTES
    Requires PowerShell 5.1+, Windows 11 24H2 or later.
    Admin rights may be required for event log source creation.
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
    $source = "PowerShell - Volume Mixer Dashboard"

    if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
        try {
            New-EventLog -LogName $logName -Source $source
        }
        catch {
            Write-Warning "Unable to create Event Log source. Run as Administrator."
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
$window.Title = "Volume Mixer & Sound Settings Dashboard"
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
$textBlockHeader.Text = "Volume Mixer & Sound Settings Dashboard"
$textBlockHeader.FontSize = 16
$textBlockHeader.FontWeight = [System.Windows.FontWeights]::Bold
$textBlockHeader.TextAlignment = [System.Windows.TextAlignment]::Center
$textBlockHeader.Margin = [System.Windows.Thickness]::new(0, 0, 0, 20)
$stackPanel.Children.Add($textBlockHeader)

# Button: Open Volume Mixer (App volume & device preferences)
$buttonVolumeMixer = New-Object System.Windows.Controls.Button
$buttonVolumeMixer.Content = "Open Volume Mixer (App Volume & Device Preferences)"
$buttonVolumeMixer.Width = 320
$buttonVolumeMixer.Margin = [System.Windows.Thickness]::new(10)
$buttonVolumeMixer.Add_Click({
    Start-Process "ms-settings:apps-volume"
    Log-Action "Opened Volume Mixer (App Volume & Device Preferences)"
})
$stackPanel.Children.Add($buttonVolumeMixer)

# Button: Open Sound Settings (Main sound page)
$buttonSoundSettings = New-Object System.Windows.Controls.Button
$buttonSoundSettings.Content = "Open Sound Settings"
$buttonSoundSettings.Width = 320
$buttonSoundSettings.Margin = [System.Windows.Thickness]::new(10)
$buttonSoundSettings.Add_Click({
    Start-Process "ms-settings:sound"
    Log-Action "Opened Sound Settings"
})
$stackPanel.Children.Add($buttonSoundSettings)

# Button: Open Microphone Privacy Settings
$buttonMicrophone = New-Object System.Windows.Controls.Button
$buttonMicrophone.Content = "Open Microphone Privacy Settings"
$buttonMicrophone.Width = 320
$buttonMicrophone.Margin = [System.Windows.Thickness]::new(10)
$buttonMicrophone.Add_Click({
    Start-Process "ms-settings:privacy-microphone"
    Log-Action "Opened Microphone Privacy Settings"
})
$stackPanel.Children.Add($buttonMicrophone)

# Button: Open Sound Control Panel (classic)
$buttonSoundControlPanel = New-Object System.Windows.Controls.Button
$buttonSoundControlPanel.Content = "Open Classic Sound Control Panel"
$buttonSoundControlPanel.Width = 320
$buttonSoundControlPanel.Margin = [System.Windows.Thickness]::new(10)
$buttonSoundControlPanel.Add_Click({
    Start-Process "mmsys.cpl"
    Log-Action "Opened Classic Sound Control Panel"
})
$stackPanel.Children.Add($buttonSoundControlPanel)

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
