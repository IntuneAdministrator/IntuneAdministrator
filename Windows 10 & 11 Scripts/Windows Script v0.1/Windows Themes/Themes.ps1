<#
.SYNOPSIS
    Interactive WPF GUI with individual buttons for Windows 11 theme-related settings pages.

.DESCRIPTION
    Each button opens a separate theme-related settings page and logs the action.

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
    $source = "PowerShell - Theme Settings Script"
    if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
        try { New-EventLog -LogName $logName -Source $source } catch { Write-Warning "Run as admin to enable event logging." }
    }
    Write-EventLog -LogName $logName -Source $source -EntryType Information -EventId 1000 -Message $message
}

# Create main window
$window = New-Object System.Windows.Window
$window.Title = "Windows 11 Theme Settings Dashboard"
$window.SizeToContent = 'WidthAndHeight'
$window.ResizeMode = [System.Windows.ResizeMode]::NoResize
$window.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterScreen

$stackPanel = New-Object System.Windows.Controls.StackPanel
$stackPanel.Orientation = [System.Windows.Controls.Orientation]::Vertical
$stackPanel.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$stackPanel.VerticalAlignment = [System.Windows.VerticalAlignment]::Center
$window.Content = $stackPanel

$textBlockHeader = New-Object System.Windows.Controls.TextBlock
$textBlockHeader.Text = "Windows 11 Theme Settings Dashboard"
$textBlockHeader.FontSize = 14
$textBlockHeader.FontWeight = [System.Windows.FontWeights]::Bold
$textBlockHeader.TextAlignment = [System.Windows.TextAlignment]::Center
$textBlockHeader.Margin = [System.Windows.Thickness]::new(0, 0, 0, 20)
$stackPanel.Children.Add($textBlockHeader)

$buttonPanel = New-Object System.Windows.Controls.StackPanel
$buttonPanel.Orientation = [System.Windows.Controls.Orientation]::Vertical
$buttonPanel.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$stackPanel.Children.Add($buttonPanel)

# Button for opening 'Themes' Settings
$buttonThemes = New-Object System.Windows.Controls.Button
$buttonThemes.Content = "Open 'Themes' Settings"
$buttonThemes.Width = 320
$buttonThemes.Margin = [System.Windows.Thickness]::new(10)
$buttonThemes.Add_Click({
    Start-Process "ms-settings:themes"
    Log-Action "Opened 'Themes' settings via PowerShell script."
})

# Button for opening 'Background' Settings
$buttonBackground = New-Object System.Windows.Controls.Button
$buttonBackground.Content = "Open 'Background' Settings"
$buttonBackground.Width = 320
$buttonBackground.Margin = [System.Windows.Thickness]::new(10)
$buttonBackground.Add_Click({
    Start-Process "ms-settings:personalization-background"
    Log-Action "Opened 'Background' settings via PowerShell script."
})

# Button for opening 'Colors' Settings
$buttonColors = New-Object System.Windows.Controls.Button
$buttonColors.Content = "Open 'Colors' Settings"
$buttonColors.Width = 320
$buttonColors.Margin = [System.Windows.Thickness]::new(10)
$buttonColors.Add_Click({
    Start-Process "ms-settings:personalization-colors"
    Log-Action "Opened 'Colors' settings via PowerShell script."
})

# Button for opening 'Lock Screen' Settings
$buttonLockScreen = New-Object System.Windows.Controls.Button
$buttonLockScreen.Content = "Open 'Lock Screen' Settings"
$buttonLockScreen.Width = 320
$buttonLockScreen.Margin = [System.Windows.Thickness]::new(10)
$buttonLockScreen.Add_Click({
    Start-Process "ms-settings:lockscreen"
    Log-Action "Opened 'Lock Screen' settings via PowerShell script."
})

# Button for opening 'Fonts' Settings
$buttonFonts = New-Object System.Windows.Controls.Button
$buttonFonts.Content = "Open 'Fonts' Settings"
$buttonFonts.Width = 320
$buttonFonts.Margin = [System.Windows.Thickness]::new(10)
$buttonFonts.Add_Click({
    Start-Process "ms-settings:fonts"
    Log-Action "Opened 'Fonts' settings via PowerShell script."
})

# Button for opening 'Taskbar' Settings
$buttonTaskbar = New-Object System.Windows.Controls.Button
$buttonTaskbar.Content = "Open 'Taskbar' Settings"
$buttonTaskbar.Width = 320
$buttonTaskbar.Margin = [System.Windows.Thickness]::new(10)
$buttonTaskbar.Add_Click({
    Start-Process "ms-settings:taskbar"
    Log-Action "Opened 'Taskbar' settings via PowerShell script."
})

# Add buttons to panel
$buttonPanel.Children.Add($buttonThemes)
$buttonPanel.Children.Add($buttonBackground)
$buttonPanel.Children.Add($buttonColors)
$buttonPanel.Children.Add($buttonLockScreen)
$buttonPanel.Children.Add($buttonFonts)
$buttonPanel.Children.Add($buttonTaskbar)

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
