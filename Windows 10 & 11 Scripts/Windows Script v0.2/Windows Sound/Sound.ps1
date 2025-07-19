<#
.SYNOPSIS
    Sound Settings Dashboard - Interactive WPF GUI for Windows 11 24H2 Sound Settings

.DESCRIPTION
    This script creates a WPF GUI with individual buttons for various Windows sound-related settings.
    Each button opens a specific ms-settings URI and logs the action to the Windows Event Log.

.AUTHOR
    Allester Padovani
    Senior IT Specialist
    Date: 2025-07-19
    Version: 1.1

.NOTES
    Requires Windows 11 24H2 or later.
    Requires PowerShell 5.1+ and admin rights for event log creation.
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

function Log-Action {
    param ([string]$message)

    $logName = "Application"
    $source = "PowerShell - Sound Settings Dashboard"

    if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
        try {
            New-EventLog -LogName $logName -Source $source
        } catch {
            Write-Warning "Run the script as Administrator to create event log source."
        }
    }

    Write-EventLog -LogName $logName -Source $source -EntryType Information -EventId 1000 -Message $message
}

# Create main window
$window = New-Object System.Windows.Window
$window.Title = "Sound Settings Dashboard"
$window.ResizeMode = [System.Windows.ResizeMode]::NoResize
$window.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterScreen

# Main vertical StackPanel
$mainPanel = New-Object System.Windows.Controls.StackPanel
$mainPanel.Orientation = [System.Windows.Controls.Orientation]::Vertical
$mainPanel.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$mainPanel.VerticalAlignment = [System.Windows.VerticalAlignment]::Top
$mainPanel.Margin = [System.Windows.Thickness]::new(10)
$window.Content = $mainPanel

# Header
$textBlockHeader = New-Object System.Windows.Controls.TextBlock
$textBlockHeader.Text = "Sound Settings Dashboard"
$textBlockHeader.FontSize = 16
$textBlockHeader.FontWeight = [System.Windows.FontWeights]::Bold
$textBlockHeader.TextAlignment = [System.Windows.TextAlignment]::Center
$textBlockHeader.Margin = [System.Windows.Thickness]::new(0,0,0,20)
$mainPanel.Children.Add($textBlockHeader)

# Grid for buttons (2 columns)
$gridButtons = New-Object System.Windows.Controls.Grid
$gridButtons.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$gridButtons.VerticalAlignment = [System.Windows.VerticalAlignment]::Top
$gridButtons.Width = 660

# Add 2 columns
for ($i=0; $i -lt 2; $i++) {
    $colDef = New-Object System.Windows.Controls.ColumnDefinition
    $colDef.Width = [System.Windows.GridLength]::new(1, [System.Windows.GridUnitType]::Star)
    $gridButtons.ColumnDefinitions.Add($colDef)
}

# Helper: Add button to Grid
function Add-ButtonToGrid {
    param(
        [System.Windows.Controls.Button]$btn,
        [int]$row,
        [int]$col
    )
    $btn.Width = 320
    $btn.Margin = [System.Windows.Thickness]::new(5)
    [System.Windows.Controls.Grid]::SetRow($btn, $row)
    [System.Windows.Controls.Grid]::SetColumn($btn, $col)
    $gridButtons.Children.Add($btn) | Out-Null
}

# Define buttons and handlers
$buttonVolumeMixer = New-Object System.Windows.Controls.Button
$buttonVolumeMixer.Content = "Volume mixer"
$buttonVolumeMixer.Add_Click({
    Start-Process "ms-settings:apps-volume"
    Log-Action "Opened 'Volume mixer'"
})

$buttonSound = New-Object System.Windows.Controls.Button
$buttonSound.Content = "Sound"
$buttonSound.Add_Click({
    Start-Process "ms-settings:sound"
    Log-Action "Opened 'Sound'"
})

$buttonSoundDevices = New-Object System.Windows.Controls.Button
$buttonSoundDevices.Content = "Sound devices"
$buttonSoundDevices.Add_Click({
    Start-Process "ms-settings:sound-devices"
    Log-Action "Opened 'Sound devices'"
})

$buttonDefaultMic = New-Object System.Windows.Controls.Button
$buttonDefaultMic.Content = "Default microphone"
$buttonDefaultMic.Add_Click({
    Start-Process "ms-settings:sound-defaultinputproperties"
    Log-Action "Opened 'Default microphone'"
})

$buttonDefaultAudioOutput = New-Object System.Windows.Controls.Button
$buttonDefaultAudioOutput.Content = "Default audio output"
$buttonDefaultAudioOutput.Add_Click({
    Start-Process "ms-settings:sound-defaultoutputproperties"
    Log-Action "Opened 'Default audio output'"
})

# Button list
$buttons = @(
    $buttonVolumeMixer,
    $buttonSound,
    $buttonSoundDevices,
    $buttonDefaultMic,
    $buttonDefaultAudioOutput
)

# Calculate rows needed
$rowsNeeded = [math]::Ceiling($buttons.Count / 2)

# Add rows
for ($i = 0; $i -lt $rowsNeeded; $i++) {
    $rowDef = New-Object System.Windows.Controls.RowDefinition
    $rowDef.Height = [System.Windows.GridLength]::Auto
    $gridButtons.RowDefinitions.Add($rowDef)
}

# Place buttons into grid
for ($i = 0; $i -lt $buttons.Count; $i++) {
    $row = [math]::Floor($i / 2)
    $col = $i % 2
    Add-ButtonToGrid -btn $buttons[$i] -row $row -col $col
}

# Add button grid
$mainPanel.Children.Add($gridButtons)

# Footer
$textBlockFooter = New-Object System.Windows.Controls.TextBlock
$textBlockFooter.Text = "Allester Padovani, Senior IT Specialist. All rights reserved."
$textBlockFooter.FontSize = 12
$textBlockFooter.FontStyle = [System.Windows.FontStyles]::Italic
$textBlockFooter.Foreground = [System.Windows.Media.Brushes]::Black
$textBlockFooter.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$textBlockFooter.Margin = [System.Windows.Thickness]::new(0,20,0,5)
$mainPanel.Children.Add($textBlockFooter)

# Dynamic height
$buttonHeightEstimate = 50
$headerHeight = 50
$footerHeight = 40
$extraPadding = 30

$windowHeight = ($rowsNeeded * $buttonHeightEstimate) + $headerHeight + $footerHeight + $extraPadding

# Final window size
$window.Width = 700
$window.Height = $windowHeight
$window.MinWidth = 700
$window.MinHeight = $windowHeight

# Show GUI
$window.ShowDialog()
