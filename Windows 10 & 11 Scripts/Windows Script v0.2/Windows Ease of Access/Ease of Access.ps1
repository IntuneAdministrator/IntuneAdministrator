<#
.SYNOPSIS
    WPF GUI with two columns of buttons for various Windows 11 Ease of Access settings.

.DESCRIPTION
    Each button opens a specific Windows 11 Ease of Access settings URI.
    Two-column layout with individually configured buttons.

.AUTHOR
    Allester Padovani
    Senior IT Specialist
    Date: 2025-07-18
    Version: 1.0
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

function Log-Action {
    param ([string]$message)
    Write-Host "[LOG] $message"
}

# Create main window
$window = New-Object System.Windows.Window
$window.Title = "Windows 11 Ease of Access Settings"
$window.ResizeMode = [System.Windows.ResizeMode]::NoResize
$window.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterScreen

# Let window size itself based on content
$window.SizeToContent = 'WidthAndHeight'

# Main vertical stack panel
$mainStack = New-Object System.Windows.Controls.StackPanel
$mainStack.Orientation = [System.Windows.Controls.Orientation]::Vertical
$mainStack.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$mainStack.VerticalAlignment = [System.Windows.VerticalAlignment]::Center
$window.Content = $mainStack

# Header text block
$header = New-Object System.Windows.Controls.TextBlock
$header.Text = "Ease of Access Settings"
$header.FontSize = 16
$header.FontWeight = [System.Windows.FontWeights]::Bold
$header.TextAlignment = [System.Windows.TextAlignment]::Center
$header.Margin = [System.Windows.Thickness]::new(0, 0, 0, 20)
$mainStack.Children.Add($header)

# Two-column container panel
$columnsPanel = New-Object System.Windows.Controls.StackPanel
$columnsPanel.Orientation = [System.Windows.Controls.Orientation]::Horizontal
$columnsPanel.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$mainStack.Children.Add($columnsPanel)

# Left column panel
$leftColumn = New-Object System.Windows.Controls.StackPanel
$leftColumn.Orientation = [System.Windows.Controls.Orientation]::Vertical
$leftColumn.Margin = [System.Windows.Thickness]::new(10, 0, 10, 0)
$columnsPanel.Children.Add($leftColumn)

# Right column panel
$rightColumn = New-Object System.Windows.Controls.StackPanel
$rightColumn.Orientation = [System.Windows.Controls.Orientation]::Vertical
$rightColumn.Margin = [System.Windows.Thickness]::new(10, 0, 10, 0)
$columnsPanel.Children.Add($rightColumn)

# Left Column Buttons

$buttonAudio = New-Object System.Windows.Controls.Button
$buttonAudio.Content = "Audio"
$buttonAudio.Width = 320
$buttonAudio.Margin = [System.Windows.Thickness]::new(10)
$buttonAudio.Add_Click({
    Start-Process "ms-settings:easeofaccess-audio"
    Log-Action "Opened Audio settings"
})
$leftColumn.Children.Add($buttonAudio)

$buttonClosedCaptions = New-Object System.Windows.Controls.Button
$buttonClosedCaptions.Content = "Closed Captions"
$buttonClosedCaptions.Width = 320
$buttonClosedCaptions.Margin = [System.Windows.Thickness]::new(10)
$buttonClosedCaptions.Add_Click({
    Start-Process "ms-settings:easeofaccess-closedcaptioning"
    Log-Action "Opened Closed Captions settings"
})
$leftColumn.Children.Add($buttonClosedCaptions)

$buttonColorFilters = New-Object System.Windows.Controls.Button
$buttonColorFilters.Content = "Color Filters"
$buttonColorFilters.Width = 320
$buttonColorFilters.Margin = [System.Windows.Thickness]::new(10)
$buttonColorFilters.Add_Click({
    Start-Process "ms-settings:easeofaccess-colorfilter"
    Log-Action "Opened Color Filters settings"
})
$leftColumn.Children.Add($buttonColorFilters)

$buttonDisplay = New-Object System.Windows.Controls.Button
$buttonDisplay.Content = "Display"
$buttonDisplay.Width = 320
$buttonDisplay.Margin = [System.Windows.Thickness]::new(10)
$buttonDisplay.Add_Click({
    Start-Process "ms-settings:easeofaccess-display"
    Log-Action "Opened Display settings"
})
$leftColumn.Children.Add($buttonDisplay)

$buttonEyeControl = New-Object System.Windows.Controls.Button
$buttonEyeControl.Content = "Eye Control"
$buttonEyeControl.Width = 320
$buttonEyeControl.Margin = [System.Windows.Thickness]::new(10)
$buttonEyeControl.Add_Click({
    Start-Process "ms-settings:easeofaccess-eyecontrol"
    Log-Action "Opened Eye Control settings"
})
$leftColumn.Children.Add($buttonEyeControl)

$buttonHearingDevices = New-Object System.Windows.Controls.Button
$buttonHearingDevices.Content = "Hearing Devices"
$buttonHearingDevices.Width = 320
$buttonHearingDevices.Margin = [System.Windows.Thickness]::new(10)
$buttonHearingDevices.Add_Click({
    Start-Process "ms-settings:easeofaccess-hearingaids"
    Log-Action "Opened Hearing Devices settings"
})
$leftColumn.Children.Add($buttonHearingDevices)

$buttonHighContrast = New-Object System.Windows.Controls.Button
$buttonHighContrast.Content = "High Contrast"
$buttonHighContrast.Width = 320
$buttonHighContrast.Margin = [System.Windows.Thickness]::new(10)
$buttonHighContrast.Add_Click({
    Start-Process "ms-settings:easeofaccess-highcontrast"
    Log-Action "Opened High Contrast settings"
})
$leftColumn.Children.Add($buttonHighContrast)

$buttonKeyboard = New-Object System.Windows.Controls.Button
$buttonKeyboard.Content = "Keyboard"
$buttonKeyboard.Width = 320
$buttonKeyboard.Margin = [System.Windows.Thickness]::new(10)
$buttonKeyboard.Add_Click({
    Start-Process "ms-settings:easeofaccess-keyboard"
    Log-Action "Opened Keyboard settings"
})
$leftColumn.Children.Add($buttonKeyboard)

# Right Column Buttons

$buttonMagnifier = New-Object System.Windows.Controls.Button
$buttonMagnifier.Content = "Magnifier"
$buttonMagnifier.Width = 320
$buttonMagnifier.Margin = [System.Windows.Thickness]::new(10)
$buttonMagnifier.Add_Click({
    Start-Process "ms-settings:easeofaccess-magnifier"
    Log-Action "Opened Magnifier settings"
})
$rightColumn.Children.Add($buttonMagnifier)

$buttonMouse = New-Object System.Windows.Controls.Button
$buttonMouse.Content = "Mouse"
$buttonMouse.Width = 320
$buttonMouse.Margin = [System.Windows.Thickness]::new(10)
$buttonMouse.Add_Click({
    Start-Process "ms-settings:easeofaccess-mouse"
    Log-Action "Opened Mouse settings"
})
$rightColumn.Children.Add($buttonMouse)

$buttonMousePointerTouch = New-Object System.Windows.Controls.Button
$buttonMousePointerTouch.Content = "Mouse Pointer & Touch"
$buttonMousePointerTouch.Width = 320
$buttonMousePointerTouch.Margin = [System.Windows.Thickness]::new(10)
$buttonMousePointerTouch.Add_Click({
    Start-Process "ms-settings:easeofaccess-mousepointer"
    Log-Action "Opened Mouse Pointer & Touch settings"
})
$rightColumn.Children.Add($buttonMousePointerTouch)

$buttonNarrator = New-Object System.Windows.Controls.Button
$buttonNarrator.Content = "Narrator"
$buttonNarrator.Width = 320
$buttonNarrator.Margin = [System.Windows.Thickness]::new(10)
$buttonNarrator.Add_Click({
    Start-Process "ms-settings:easeofaccess-narrator"
    Log-Action "Opened Narrator settings"
})
$rightColumn.Children.Add($buttonNarrator)

$buttonSpeech = New-Object System.Windows.Controls.Button
$buttonSpeech.Content = "Speech"
$buttonSpeech.Width = 320
$buttonSpeech.Margin = [System.Windows.Thickness]::new(10)
$buttonSpeech.Add_Click({
    Start-Process "ms-settings:easeofaccess-speechrecognition"
    Log-Action "Opened Speech settings"
})
$rightColumn.Children.Add($buttonSpeech)

$buttonTextCursor = New-Object System.Windows.Controls.Button
$buttonTextCursor.Content = "Text Cursor"
$buttonTextCursor.Width = 320
$buttonTextCursor.Margin = [System.Windows.Thickness]::new(10)
$buttonTextCursor.Add_Click({
    Start-Process "ms-settings:easeofaccess-cursor"
    Log-Action "Opened Text Cursor settings"
})
$rightColumn.Children.Add($buttonTextCursor)

$buttonVisualEffects = New-Object System.Windows.Controls.Button
$buttonVisualEffects.Content = "Visual Effects"
$buttonVisualEffects.Width = 320
$buttonVisualEffects.Margin = [System.Windows.Thickness]::new(10)
$buttonVisualEffects.Add_Click({
    Start-Process "ms-settings:easeofaccess-visualeffects"
    Log-Action "Opened Visual Effects settings"
})
$rightColumn.Children.Add($buttonVisualEffects)

# Footer text
$footer = New-Object System.Windows.Controls.TextBlock
$footer.Text = "Allester Padovani, Senior IT Specialist. All rights reserved."
$footer.FontSize = 12
$footer.FontStyle = [System.Windows.FontStyles]::Italic
$footer.Foreground = [System.Windows.Media.Brushes]::Black
$footer.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$footer.Margin = [System.Windows.Thickness]::new(0, 20, 0, 5)
$mainStack.Children.Add($footer)

# Show the window
$window.ShowDialog()
