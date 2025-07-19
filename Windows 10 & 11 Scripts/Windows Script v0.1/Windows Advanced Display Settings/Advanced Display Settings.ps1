<#
.SYNOPSIS
    Advanced Display Settings Utilities Dashboard for Windows 11 24H2.

.DESCRIPTION
    Provides a WPF GUI with buttons to:
    - Check if Advanced Display Settings are supported and show info
    - Open the Advanced Display Settings page
    - Open Display Settings main page
    - Open Color Calibration tool
    - Open Display Adapter Properties
    Each button logs its action to the Application event log.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-15
    Version     : 1.0

.NOTES
    Requires PowerShell 5.1+, Windows 11 24H2 or later.
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Log-Action {
    param (
        [string]$message,
        [string]$source = "PowerShell - Advanced Display Dashboard"
    )

    $logName = "Application"
    if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
        try { New-EventLog -LogName $logName -Source $source } catch {}
    }

    Write-EventLog -LogName $logName -Source $source -EntryType Information -EventId 1000 -Message $message
}

function Check-AdvancedDisplaySupport {
    try {
        $displaySupported = Get-CimInstance -ClassName Win32_VideoController | Select-Object -ExpandProperty VideoModeDescription
        return ($displaySupported -and $displaySupported.Count -gt 0)
    }
    catch {
        return $false
    }
}

function Show-AdvancedDisplaySupportMessage {
    $supported = Check-AdvancedDisplaySupport
    if ($supported) {
        [System.Windows.Forms.MessageBox]::Show(
            "Advanced Display Settings are supported on this device.",
            "Support Check",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Information
        )
    }
    else {
        [System.Windows.Forms.MessageBox]::Show(
            "Advanced Display Settings are NOT supported on this device.",
            "Support Check",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Warning
        )
    }
}

# Create WPF Window
$window = New-Object System.Windows.Window
$window.Title = "Advanced Display Settings Dashboard"
$window.SizeToContent = 'WidthAndHeight'
$window.ResizeMode = [System.Windows.ResizeMode]::NoResize
$window.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterScreen

# Main stack panel
$stackPanel = New-Object System.Windows.Controls.StackPanel
$stackPanel.Orientation = [System.Windows.Controls.Orientation]::Vertical
$stackPanel.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$stackPanel.VerticalAlignment = [System.Windows.VerticalAlignment]::Center
$window.Content = $stackPanel

# Header
$textBlockHeader = New-Object System.Windows.Controls.TextBlock
$textBlockHeader.Text = "Advanced Display Utilities"
$textBlockHeader.FontSize = 16
$textBlockHeader.FontWeight = [System.Windows.FontWeights]::Bold
$textBlockHeader.TextAlignment = [System.Windows.TextAlignment]::Center
$textBlockHeader.Margin = [System.Windows.Thickness]::new(0, 0, 0, 20)
$stackPanel.Children.Add($textBlockHeader)

# Button: Check Advanced Display Support
$btnCheckSupport = New-Object System.Windows.Controls.Button
$btnCheckSupport.Content = "Check Advanced Display Support"
$btnCheckSupport.Width = 320
$btnCheckSupport.Margin = [System.Windows.Thickness]::new(10)
$btnCheckSupport.Add_Click({
    Show-AdvancedDisplaySupportMessage
    Log-Action "Checked Advanced Display Settings support."
})
$stackPanel.Children.Add($btnCheckSupport)

# Button: Open Advanced Display Settings
$btnOpenAdvanced = New-Object System.Windows.Controls.Button
$btnOpenAdvanced.Content = "Open Advanced Display Settings"
$btnOpenAdvanced.Width = 320
$btnOpenAdvanced.Margin = [System.Windows.Thickness]::new(10)
$btnOpenAdvanced.Add_Click({
    Start-Process "ms-settings:display-advanced"
    Log-Action "Opened Advanced Display Settings page."
})
$stackPanel.Children.Add($btnOpenAdvanced)

# Button: Open Display Settings main page
$btnOpenDisplaySettings = New-Object System.Windows.Controls.Button
$btnOpenDisplaySettings.Content = "Open Display Settings"
$btnOpenDisplaySettings.Width = 320
$btnOpenDisplaySettings.Margin = [System.Windows.Thickness]::new(10)
$btnOpenDisplaySettings.Add_Click({
    Start-Process "ms-settings:display"
    Log-Action "Opened Display Settings page."
})
$stackPanel.Children.Add($btnOpenDisplaySettings)

# Button: Open Color Calibration Tool
$btnColorCalib = New-Object System.Windows.Controls.Button
$btnColorCalib.Content = "Open Color Calibration"
$btnColorCalib.Width = 320
$btnColorCalib.Margin = [System.Windows.Thickness]::new(10)
$btnColorCalib.Add_Click({
    Start-Process "dccw.exe"
    Log-Action "Opened Color Calibration tool."
})
$stackPanel.Children.Add($btnColorCalib)

# Button: Open Display Adapter Properties
$btnDisplayAdapter = New-Object System.Windows.Controls.Button
$btnDisplayAdapter.Content = "Open Display Adapter Properties"
$btnDisplayAdapter.Width = 320
$btnDisplayAdapter.Margin = [System.Windows.Thickness]::new(10)
$btnDisplayAdapter.Add_Click({
    Start-Process "desk.cpl"
    Log-Action "Opened Display Adapter Properties."
})
$stackPanel.Children.Add($btnDisplayAdapter)

# Footer
$textBlockFooter = New-Object System.Windows.Controls.TextBlock
$textBlockFooter.Text = "Allester Padovani, Senior IT Specialist"
$textBlockFooter.FontSize = 12
$textBlockFooter.FontStyle = [System.Windows.FontStyles]::Italic
$textBlockFooter.Foreground = [System.Windows.Media.Brushes]::Black
$textBlockFooter.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$textBlockFooter.Margin = [System.Windows.Thickness]::new(0, 20, 0, 5)
$stackPanel.Children.Add($textBlockFooter)

# Show Window
$window.ShowDialog()
