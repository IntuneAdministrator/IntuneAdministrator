<#
.SYNOPSIS
    WPF GUI to launch Windows 11 24H2 Apps & Features and related app management pages directly with logging.

.DESCRIPTION
    Provides a modern WPF interface with buttons to open Apps & Features, Optional Features,
    Default Apps, Startup Apps, and Installed Apps (Control Panel) settings pages without confirmation dialogs.
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
    $source = "PowerShell - Apps Features Launcher"

    if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
        try {
            New-EventLog -LogName $logName -Source $source
        } catch {
            Write-Warning "Unable to create Event Log source. Run as Administrator."
        }
    }

    Write-EventLog -LogName $logName -Source $source -EntryType Information -EventId 1000 -Message $message
}

$window = New-Object System.Windows.Window
$window.Title = "Apps & Features Launcher"
$window.SizeToContent = 'WidthAndHeight'
$window.ResizeMode = [System.Windows.ResizeMode]::NoResize
$window.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterScreen

$stackPanel = New-Object System.Windows.Controls.StackPanel
$stackPanel.Orientation = [System.Windows.Controls.Orientation]::Vertical
$stackPanel.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$stackPanel.VerticalAlignment = [System.Windows.VerticalAlignment]::Center
$window.Content = $stackPanel

$textBlockHeader = New-Object System.Windows.Controls.TextBlock
$textBlockHeader.Text = "Apps & Features Management"
$textBlockHeader.FontSize = 16
$textBlockHeader.FontWeight = [System.Windows.FontWeights]::Bold
$textBlockHeader.TextAlignment = [System.Windows.TextAlignment]::Center
$textBlockHeader.Margin = [System.Windows.Thickness]::new(0,0,0,20)
$stackPanel.Children.Add($textBlockHeader)

function New-Button {
    param (
        [string]$content,
        [scriptblock]$onClick
    )
    $btn = New-Object System.Windows.Controls.Button
    $btn.Content = $content
    $btn.Width = 320
    $btn.Margin = [System.Windows.Thickness]::new(10)
    $btn.Add_Click($onClick)
    $stackPanel.Children.Add($btn)
}

# Apps & Features main page
New-Button -content "Open Apps & Features" -onClick {
    Start-Process "ms-settings:appsfeatures"
    Log-Action "Opened Apps & Features page."
}

# Optional Features page
New-Button -content "Open Optional Features" -onClick {
    Start-Process "ms-settings:optionalfeatures"
    Log-Action "Opened Optional Features page."
}

# Default Apps page
New-Button -content "Open Default Apps" -onClick {
    Start-Process "ms-settings:defaultapps"
    Log-Action "Opened Default Apps page."
}

# Startup Apps page
New-Button -content "Open Startup Apps" -onClick {
    Start-Process "ms-settings:startupapps"
    Log-Action "Opened Startup Apps page."
}

# Installed Apps via Control Panel (Programs & Features)
New-Button -content "Open Installed Apps" -onClick {
    Start-Process "appwiz.cpl"
    Log-Action "Opened Installed Apps (appwiz.cpl)."
}

# Footer TextBlock
$textBlockFooter = New-Object System.Windows.Controls.TextBlock
$textBlockFooter.Text = "Allester Padovani, Senior IT Specialist. All rights reserved."
$textBlockFooter.FontSize = 12
$textBlockFooter.FontStyle = [System.Windows.FontStyles]::Italic
$textBlockFooter.Foreground = [System.Windows.Media.Brushes]::Black
$textBlockFooter.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$textBlockFooter.Margin = [System.Windows.Thickness]::new(0,20,0,5)
$stackPanel.Children.Add($textBlockFooter)

$window.ShowDialog()
