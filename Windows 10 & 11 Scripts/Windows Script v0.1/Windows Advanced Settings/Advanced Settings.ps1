<#
.SYNOPSIS
    WPF GUI to launch various Windows 11 Advanced Settings pages directly with logging.

.DESCRIPTION
    Provides a modern WPF interface with buttons that open advanced settings pages
    such as Network, Display, Sound, Power, and Storage without confirmation dialogs.
    Logs each action to the Windows Event Log under a custom source.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-15
    Version     : 1.0

.NOTES
    Requires: PowerShell 5.1+, Windows 11 24H2 or newer
    Run as Administrator to create event log sources if needed.
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

function Log-Action {
    param([string]$message)
    $logName = "Application"
    $source = "PowerShell - Advanced Settings Launcher"

    if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
        try {
            New-EventLog -LogName $logName -Source $source
        } catch {
            Write-Warning "Unable to create Event Log source. Run as Administrator."
        }
    }

    Write-EventLog -LogName $logName -Source $source -EntryType Information -EventId 1000 -Message $message
}

# Create Window
$window = New-Object System.Windows.Window
$window.Title = "Advanced Settings Launcher"
$window.SizeToContent = 'WidthAndHeight'
$window.ResizeMode = 'NoResize'
$window.WindowStartupLocation = 'CenterScreen'

# Main StackPanel
$stackPanel = New-Object System.Windows.Controls.StackPanel
$stackPanel.Orientation = 'Vertical'
$stackPanel.HorizontalAlignment = 'Center'
$stackPanel.VerticalAlignment = 'Center'
$window.Content = $stackPanel

# Header
$textBlockHeader = New-Object System.Windows.Controls.TextBlock
$textBlockHeader.Text = "Advanced Settings Launcher"
$textBlockHeader.FontSize = 16
$textBlockHeader.FontWeight = 'Bold'
$textBlockHeader.TextAlignment = 'Center'
$textBlockHeader.Margin = [System.Windows.Thickness]::new(0,0,0,20)
$stackPanel.Children.Add($textBlockHeader)

# Button container
$buttonPanel = New-Object System.Windows.Controls.StackPanel
$buttonPanel.Orientation = 'Vertical'
$buttonPanel.HorizontalAlignment = 'Center'
$stackPanel.Children.Add($buttonPanel)

function New-Button {
    param (
        [string]$content,
        [scriptblock]$onClick
    )
    $btn = New-Object System.Windows.Controls.Button
    $btn.Content = $content
    $btn.Width = 320
    $btn.Margin = [System.Windows.Thickness]::new(5)
    $btn.Add_Click($onClick)
    $buttonPanel.Children.Add($btn)
}

# Buttons
New-Button -content "Open Advanced Network Settings" -onClick {
    Start-Process "ms-settings:network-advancedsettings"
    Log-Action "Opened Advanced Network Settings."
}

New-Button -content "Open Advanced Display Settings" -onClick {
    Start-Process "ms-settings:display-advanced"
    Log-Action "Opened Advanced Display Settings."
}

New-Button -content "Open Advanced Sound Settings" -onClick {
    Start-Process "ms-settings:sound-device-properties"
    Log-Action "Opened Advanced Sound Settings."
}

New-Button -content "Open Advanced Power Settings" -onClick {
    Start-Process "powercfg.cpl"
    Log-Action "Opened Advanced Power Settings."
}

New-Button -content "Open Advanced Storage Settings" -onClick {
    Start-Process "ms-settings:storagesense"
    Log-Action "Opened Advanced Storage Settings."
}

# Footer
$textBlockFooter = New-Object System.Windows.Controls.TextBlock
$textBlockFooter.Text = "Allester Padovani, Senior IT Specialist. All rights reserved."
$textBlockFooter.FontSize = 12
$textBlockFooter.FontStyle = [System.Windows.FontStyles]::Italic
$textBlockFooter.Foreground = [System.Windows.Media.Brushes]::Black
$textBlockFooter.HorizontalAlignment = 'Center'
$textBlockFooter.Margin = [System.Windows.Thickness]::new(0,20,0,5)
$stackPanel.Children.Add($textBlockFooter)

# Show UI
$window.ShowDialog()
