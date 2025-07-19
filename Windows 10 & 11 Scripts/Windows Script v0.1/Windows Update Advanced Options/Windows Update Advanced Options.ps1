<#
.SYNOPSIS
    Windows Update Management Dashboard with individual buttons for update-related settings on Windows 11 24H2.

.DESCRIPTION
    WPF GUI with buttons for Windows Update pages such as main update, advanced options, update history, delivery optimization.
    Each button launches the respective ms-settings URI and logs the action.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-19
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
    $source = "PowerShell - Windows Update Dashboard"

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
$window.Title = "Windows Update Management Dashboard"
# Set fixed width and height for initial layout
$window.Width = 420
$window.Height = 350
$window.ResizeMode = [System.Windows.ResizeMode]::NoResize
$window.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterScreen

# Let window size itself based on content
$window.SizeToContent = 'WidthAndHeight'

# Main StackPanel
$stackPanel = New-Object System.Windows.Controls.StackPanel
$stackPanel.Orientation = [System.Windows.Controls.Orientation]::Vertical
$stackPanel.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$stackPanel.VerticalAlignment = [System.Windows.VerticalAlignment]::Center
$window.Content = $stackPanel

# Header TextBlock
$textBlockHeader = New-Object System.Windows.Controls.TextBlock
$textBlockHeader.Text = "Windows Update Management Dashboard"
$textBlockHeader.FontSize = 16
$textBlockHeader.FontWeight = [System.Windows.FontWeights]::Bold
$textBlockHeader.TextAlignment = [System.Windows.TextAlignment]::Center
$textBlockHeader.Margin = [System.Windows.Thickness]::new(0, 0, 0, 20)
$stackPanel.Children.Add($textBlockHeader)

# Buttons setup with uniform width 320 (per your layout request)
# Button: Open Windows Update Settings
$buttonWindowsUpdate = New-Object System.Windows.Controls.Button
$buttonWindowsUpdate.Content = "Open Windows Update Settings"
$buttonWindowsUpdate.Width = 320
$buttonWindowsUpdate.Margin = [System.Windows.Thickness]::new(10)
$buttonWindowsUpdate.Add_Click({
    Start-Process "ms-settings:windowsupdate"
    Log-Action "Opened Windows Update Settings"
})
$stackPanel.Children.Add($buttonWindowsUpdate)

# Button: Open Advanced Options
$buttonAdvancedOptions = New-Object System.Windows.Controls.Button
$buttonAdvancedOptions.Content = "Open Advanced Options"
$buttonAdvancedOptions.Width = 320
$buttonAdvancedOptions.Margin = [System.Windows.Thickness]::new(10)
$buttonAdvancedOptions.Add_Click({
    Start-Process "ms-settings:windowsupdate-options"
    Log-Action "Opened Windows Update Advanced Options"
})
$stackPanel.Children.Add($buttonAdvancedOptions)

# Button: Open Update History
$buttonUpdateHistory = New-Object System.Windows.Controls.Button
$buttonUpdateHistory.Content = "Open Update History"
$buttonUpdateHistory.Width = 320
$buttonUpdateHistory.Margin = [System.Windows.Thickness]::new(10)
$buttonUpdateHistory.Add_Click({
    Start-Process "ms-settings:windowsupdate-history"
    Log-Action "Opened Windows Update History"
})
$stackPanel.Children.Add($buttonUpdateHistory)

# Button: Open Delivery Optimization
$buttonDeliveryOptimization = New-Object System.Windows.Controls.Button
$buttonDeliveryOptimization.Content = "Open Delivery Optimization"
$buttonDeliveryOptimization.Width = 320
$buttonDeliveryOptimization.Margin = [System.Windows.Thickness]::new(10)
$buttonDeliveryOptimization.Add_Click({
    Start-Process "ms-settings:delivery-optimization"
    Log-Action "Opened Delivery Optimization Settings"
})
$stackPanel.Children.Add($buttonDeliveryOptimization)

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
