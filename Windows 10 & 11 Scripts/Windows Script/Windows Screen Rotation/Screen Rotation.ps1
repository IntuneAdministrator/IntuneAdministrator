<#
.SYNOPSIS
    Prompts user to open the Screen Rotation settings page on Windows 11 24H2 using a WPF GUI.

.DESCRIPTION
    Displays a WPF window asking the user if they want to open the Screen Rotation settings.
    Clicking Yes opens the settings page and logs the action.
    Clicking No logs cancellation and closes the window.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-19
    Version     : 1.0

.NOTES
    - Tested on Windows 11 24H2.
    - Requires PowerShell 5.1+ with PresentationFramework loaded.
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Add-Type -AssemblyName PresentationFramework

function Log-Action {
    param ([string]$message)
    $logName = "Application"
    $source = "Screen Rotation Settings"
    if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
        try { New-EventLog -LogName $logName -Source $source } catch {}
    }
    Write-EventLog -LogName $logName -Source $source -EntryType Information -EventId 1000 -Message $message
}

# Create window
$window = New-Object System.Windows.Window
$window.Title = "Open Screen Rotation Settings?"
$window.SizeToContent = 'WidthAndHeight'
$window.ResizeMode = [System.Windows.ResizeMode]::NoResize
$window.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterScreen

# StackPanel container
$stackPanel = New-Object System.Windows.Controls.StackPanel
$stackPanel.Orientation = [System.Windows.Controls.Orientation]::Vertical
$stackPanel.Margin = [System.Windows.Thickness]::new(20)
$window.Content = $stackPanel

# TextBlock prompt
$textBlock = New-Object System.Windows.Controls.TextBlock
$textBlock.Text = "Do you want to open the Screen Rotation settings page?"
$textBlock.FontSize = 14
$textBlock.Margin = [System.Windows.Thickness]::new(0, 0, 0, 20)
$textBlock.TextWrapping = "Wrap"
$stackPanel.Children.Add($textBlock)

# Buttons panel (horizontal)
$buttonPanel = New-Object System.Windows.Controls.StackPanel
$buttonPanel.Orientation = [System.Windows.Controls.Orientation]::Horizontal
$buttonPanel.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$buttonPanel.Margin = [System.Windows.Thickness]::new(0, 10, 0, 0)
$stackPanel.Children.Add($buttonPanel)

# Yes button
$btnYes = New-Object System.Windows.Controls.Button
$btnYes.Content = "Yes"
$btnYes.Width = 320
$btnYes.Margin = [System.Windows.Thickness]::new(5,0,5,0)
$btnYes.Add_Click({
    Start-Process "ms-settings:screenrotation"
    Log-Action "User opened Screen Rotation settings."
    $window.Close()
})
$buttonPanel.Children.Add($btnYes)

# No button
$btnNo = New-Object System.Windows.Controls.Button
$btnNo.Content = "No"
$btnNo.Width = 320
$btnNo.Margin = [System.Windows.Thickness]::new(5,0,5,0)
$btnNo.Add_Click({
    Log-Action "User canceled opening Screen Rotation settings."
    $window.Close()
})
$buttonPanel.Children.Add($btnNo)

# Show window
$window.ShowDialog()
