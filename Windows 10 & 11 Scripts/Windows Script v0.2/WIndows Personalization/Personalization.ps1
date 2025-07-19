<#
.SYNOPSIS
    WPF GUI for Personalization settings with two columns of individually setup buttons.

.DESCRIPTION
    Each button opens a specific Windows 11 Personalization settings URI.
    Buttons arranged in 2 columns: 8 buttons left, 8 buttons right.

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

# Main window setup
$window = New-Object System.Windows.Window
$window.Title = "Personalization Settings"
# Remove fixed Width and Height to allow auto-sizing
#$window.Width = 720
#$window.Height = 500
$window.ResizeMode = [System.Windows.ResizeMode]::NoResize
$window.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterScreen

# Let window size itself based on content
$window.SizeToContent = 'WidthAndHeight'

# Main vertical StackPanel
$mainStack = New-Object System.Windows.Controls.StackPanel
$mainStack.Orientation = [System.Windows.Controls.Orientation]::Vertical
$mainStack.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$mainStack.VerticalAlignment = [System.Windows.VerticalAlignment]::Center
$window.Content = $mainStack

# Header TextBlock
$header = New-Object System.Windows.Controls.TextBlock
$header.Text = "Personalization Settings"
$header.FontSize = 16
$header.FontWeight = [System.Windows.FontWeights]::Bold
$header.TextAlignment = [System.Windows.TextAlignment]::Center
$header.Margin = [System.Windows.Thickness]::new(0, 0, 0, 20)
$mainStack.Children.Add($header)

# Two-column panel container
$columnsPanel = New-Object System.Windows.Controls.StackPanel
$columnsPanel.Orientation = [System.Windows.Controls.Orientation]::Horizontal
$columnsPanel.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$mainStack.Children.Add($columnsPanel)

# Left column
$leftColumn = New-Object System.Windows.Controls.StackPanel
$leftColumn.Orientation = [System.Windows.Controls.Orientation]::Vertical
$leftColumn.Margin = [System.Windows.Thickness]::new(10, 0, 10, 0)
$columnsPanel.Children.Add($leftColumn)

# Right column
$rightColumn = New-Object System.Windows.Controls.StackPanel
$rightColumn.Orientation = [System.Windows.Controls.Orientation]::Vertical
$rightColumn.Margin = [System.Windows.Thickness]::new(10, 0, 10, 0)
$columnsPanel.Children.Add($rightColumn)

# Left column buttons (8 total)

$btnBackground = New-Object System.Windows.Controls.Button
$btnBackground.Content = "Background"
$btnBackground.Width = 330
$btnBackground.Margin = [System.Windows.Thickness]::new(10)
$btnBackground.Add_Click({
    Start-Process "ms-settings:personalization-background"
    Log-Action "Opened Background settings"
})
$leftColumn.Children.Add($btnBackground)

$btnStartFolders = New-Object System.Windows.Controls.Button
$btnStartFolders.Content = "Choose Folders on Start"
$btnStartFolders.Width = 330
$btnStartFolders.Margin = [System.Windows.Thickness]::new(10)
$btnStartFolders.Add_Click({
    Start-Process "ms-settings:personalization-start-places"
    Log-Action "Opened Choose Folders on Start settings"
})
$leftColumn.Children.Add($btnStartFolders)

$btnColors = New-Object System.Windows.Controls.Button
$btnColors.Content = "Colors"
$btnColors.Width = 330
$btnColors.Margin = [System.Windows.Thickness]::new(10)
$btnColors.Add_Click({
    Start-Process "ms-settings:personalization-colors"
    Log-Action "Opened Colors settings"
})
$leftColumn.Children.Add($btnColors)

$btnColorsSimple = New-Object System.Windows.Controls.Button
$btnColorsSimple.Content = "Colors (Alternate URI)"
$btnColorsSimple.Width = 330
$btnColorsSimple.Margin = [System.Windows.Thickness]::new(10)
$btnColorsSimple.Add_Click({
    Start-Process "ms-settings:colors"
    Log-Action "Opened Colors (Alternate URI) settings"
})
$leftColumn.Children.Add($btnColorsSimple)

$btnCopilotKey = New-Object System.Windows.Controls.Button
$btnCopilotKey.Content = "Customize Copilot Key"
$btnCopilotKey.Width = 330
$btnCopilotKey.Margin = [System.Windows.Thickness]::new(10)
$btnCopilotKey.Add_Click({
    Start-Process "ms-settings:personalization-textinput-copilot-hardwarekey"
    Log-Action "Opened Customize Copilot Key settings"
})
$leftColumn.Children.Add($btnCopilotKey)

$btnDynamicLighting = New-Object System.Windows.Controls.Button
$btnDynamicLighting.Content = "Dynamic Lighting"
$btnDynamicLighting.Width = 330
$btnDynamicLighting.Margin = [System.Windows.Thickness]::new(10)
$btnDynamicLighting.Add_Click({
    Start-Process "ms-settings:personalization-lighting"
    Log-Action "Opened Dynamic Lighting settings"
})
$leftColumn.Children.Add($btnDynamicLighting)

$btnFonts = New-Object System.Windows.Controls.Button
$btnFonts.Content = "Fonts"
$btnFonts.Width = 330
$btnFonts.Margin = [System.Windows.Thickness]::new(10)
$btnFonts.Add_Click({
    Start-Process "ms-settings:fonts"
    Log-Action "Opened Fonts settings"
})
$leftColumn.Children.Add($btnFonts)

$btnGlance = New-Object System.Windows.Controls.Button
$btnGlance.Content = "Glance (Deprecated)"
$btnGlance.Width = 330
$btnGlance.Margin = [System.Windows.Thickness]::new(10)
$btnGlance.Add_Click({
    Start-Process "ms-settings:personalization-glance"
    Log-Action "Opened Glance settings"
})
$leftColumn.Children.Add($btnGlance)

# Right column buttons (8 total)

$btnLockScreen = New-Object System.Windows.Controls.Button
$btnLockScreen.Content = "Lock Screen"
$btnLockScreen.Width = 330
$btnLockScreen.Margin = [System.Windows.Thickness]::new(10)
$btnLockScreen.Add_Click({
    Start-Process "ms-settings:lockscreen"
    Log-Action "Opened Lock Screen settings"
})
$rightColumn.Children.Add($btnLockScreen)

$btnNavigationBar = New-Object System.Windows.Controls.Button
$btnNavigationBar.Content = "Navigation Bar (Deprecated)"
$btnNavigationBar.Width = 330
$btnNavigationBar.Margin = [System.Windows.Thickness]::new(10)
$btnNavigationBar.Add_Click({
    Start-Process "ms-settings:personalization-navbar"
    Log-Action "Opened Navigation Bar settings"
})
$rightColumn.Children.Add($btnNavigationBar)

$btnPersonalizationCategory = New-Object System.Windows.Controls.Button
$btnPersonalizationCategory.Content = "Personalization Category"
$btnPersonalizationCategory.Width = 330
$btnPersonalizationCategory.Margin = [System.Windows.Thickness]::new(10)
$btnPersonalizationCategory.Add_Click({
    Start-Process "ms-settings:personalization"
    Log-Action "Opened Personalization Category settings"
})
$rightColumn.Children.Add($btnPersonalizationCategory)

$btnStart = New-Object System.Windows.Controls.Button
$btnStart.Content = "Start"
$btnStart.Width = 330
$btnStart.Margin = [System.Windows.Thickness]::new(10)
$btnStart.Add_Click({
    Start-Process "ms-settings:personalization-start"
    Log-Action "Opened Start settings"
})
$rightColumn.Children.Add($btnStart)

$btnTaskbar = New-Object System.Windows.Controls.Button
$btnTaskbar.Content = "Taskbar"
$btnTaskbar.Width = 330
$btnTaskbar.Margin = [System.Windows.Thickness]::new(10)
$btnTaskbar.Add_Click({
    Start-Process "ms-settings:taskbar"
    Log-Action "Opened Taskbar settings"
})
$rightColumn.Children.Add($btnTaskbar)

$btnTextInput = New-Object System.Windows.Controls.Button
$btnTextInput.Content = "Text Input"
$btnTextInput.Width = 330
$btnTextInput.Margin = [System.Windows.Thickness]::new(10)
$btnTextInput.Add_Click({
    Start-Process "ms-settings:personalization-textinput"
    Log-Action "Opened Text Input settings"
})
$rightColumn.Children.Add($btnTextInput)

$btnTouchKeyboard = New-Object System.Windows.Controls.Button
$btnTouchKeyboard.Content = "Touch Keyboard"
$btnTouchKeyboard.Width = 330
$btnTouchKeyboard.Margin = [System.Windows.Thickness]::new(10)
$btnTouchKeyboard.Add_Click({
    Start-Process "ms-settings:personalization-touchkeyboard"
    Log-Action "Opened Touch Keyboard settings"
})
$rightColumn.Children.Add($btnTouchKeyboard)

$btnThemes = New-Object System.Windows.Controls.Button
$btnThemes.Content = "Themes"
$btnThemes.Width = 330
$btnThemes.Margin = [System.Windows.Thickness]::new(10)
$btnThemes.Add_Click({
    Start-Process "ms-settings:themes"
    Log-Action "Opened Themes settings"
})
$rightColumn.Children.Add($btnThemes)

# Footer TextBlock
$footer = New-Object System.Windows.Controls.TextBlock
$footer.Text = "Allester Padovani, Senior IT Specialist. All rights reserved."
$footer.FontSize = 12
$footer.FontStyle = [System.Windows.FontStyles]::Italic
$footer.Foreground = [System.Windows.Media.Brushes]::Black
$footer.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$footer.Margin = [System.Windows.Thickness]::new(0, 20, 0, 5)
$mainStack.Children.Add($footer)

# Show window
$window.ShowDialog()
