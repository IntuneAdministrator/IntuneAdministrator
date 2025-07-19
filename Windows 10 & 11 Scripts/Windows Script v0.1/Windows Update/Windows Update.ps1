<#
.SYNOPSIS
    Interactive WPF GUI with individual buttons for Windows Update-related settings on Windows 11 24H2.

.DESCRIPTION
    Provides a user-friendly GUI with buttons to open various Windows Update pages.
    Each button logs its action in the Application event log for auditing.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-19
    Version     : 1.0

.NOTES
    Requires PowerShell 5.1+, Windows 11 24H2+, admin rights for event log creation.
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

function Log-Action {
    param ([string]$message)
    $logName = "Application"
    $source = "PowerShell - Windows Update Script"
    if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
        try { New-EventLog -LogName $logName -Source $source } catch { Write-Warning "Run as admin to enable event logging." }
    }
    Write-EventLog -LogName $logName -Source $source -EntryType Information -EventId 1000 -Message $message
}

# Create main window
$window = New-Object System.Windows.Window
$window.Title = "Windows Update Management Dashboard"
# Let window size itself based on content
$window.SizeToContent = 'WidthAndHeight'
$window.ResizeMode = [System.Windows.ResizeMode]::NoResize
$window.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterScreen

$stackPanel = New-Object System.Windows.Controls.StackPanel
$stackPanel.Orientation = [System.Windows.Controls.Orientation]::Vertical
$stackPanel.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$stackPanel.VerticalAlignment = [System.Windows.VerticalAlignment]::Center
$window.Content = $stackPanel

$textBlockHeader = New-Object System.Windows.Controls.TextBlock
$textBlockHeader.Text = "Windows Update Management Dashboard"
$textBlockHeader.FontSize = 14
$textBlockHeader.FontWeight = [System.Windows.FontWeights]::Bold
$textBlockHeader.TextAlignment = [System.Windows.TextAlignment]::Center
$textBlockHeader.Margin = [System.Windows.Thickness]::new(0, 0, 0, 20)
$stackPanel.Children.Add($textBlockHeader)

$buttonPanel = New-Object System.Windows.Controls.StackPanel
$buttonPanel.Orientation = [System.Windows.Controls.Orientation]::Vertical
$buttonPanel.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$stackPanel.Children.Add($buttonPanel)

# Windows Update Settings
$buttonWindowsUpdate = New-Object System.Windows.Controls.Button
$buttonWindowsUpdate.Content = "Open Windows Update Settings"
$buttonWindowsUpdate.Width = 320
$buttonWindowsUpdate.Margin = [System.Windows.Thickness]::new(10)
$buttonWindowsUpdate.Add_Click({
    Start-Process "ms-settings:windowsupdate"
    Log-Action "Opened Windows Update Settings."
})

# Update History
$buttonUpdateHistory = New-Object System.Windows.Controls.Button
$buttonUpdateHistory.Content = "View Update History"
$buttonUpdateHistory.Width = 320
$buttonUpdateHistory.Margin = [System.Windows.Thickness]::new(10)
$buttonUpdateHistory.Add_Click({
    Start-Process "ms-settings:windowsupdate-history"
    Log-Action "Viewed Update History."
})

# Delivery Optimization
$buttonDeliveryOptimization = New-Object System.Windows.Controls.Button
$buttonDeliveryOptimization.Content = "Open Delivery Optimization Settings"
$buttonDeliveryOptimization.Width = 320
$buttonDeliveryOptimization.Margin = [System.Windows.Thickness]::new(10)
$buttonDeliveryOptimization.Add_Click({
    Start-Process "ms-settings:delivery-optimization"
    Log-Action "Opened Delivery Optimization Settings."
})

# Add buttons to panel
$buttonPanel.Children.Add($buttonWindowsUpdate)
$buttonPanel.Children.Add($buttonUpdateHistory)
$buttonPanel.Children.Add($buttonDeliveryOptimization)

# Footer
$textBlockFooter = New-Object System.Windows.Controls.TextBlock
$textBlockFooter.Text = "Allester Padovani, Senior IT Specialist. All rights reserved."
$textBlockFooter.FontSize = 12
$textBlockFooter.FontStyle = [System.Windows.FontStyles]::Italic
$textBlockFooter.Foreground = [System.Windows.Media.Brushes]::Black
$textBlockFooter.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$textBlockFooter.Margin = [System.Windows.Thickness]::new(0, 20, 0, 5)
$stackPanel.Children.Add($textBlockFooter)

$window.ShowDialog()
