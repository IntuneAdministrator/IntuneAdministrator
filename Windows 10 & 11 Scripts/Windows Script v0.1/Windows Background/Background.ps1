<#
.SYNOPSIS
    WPF GUI for launching Background and Personalization settings in Windows 11 24H2.

.DESCRIPTION
    Provides a clean GUI with separately defined buttons (no function loops) for each setting.
    Logs all actions to the Event Log without confirmation prompts.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-15
    Version     : 1.0

.NOTES
    Compatibility: Windows 11 24H2
    Requires Admin (on first use) to create Event Log source
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

function Log-Action {
    param([string]$message)

    $logName = "Application"
    $source = "PowerShell - Personalization Launcher"

    if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
        try {
            New-EventLog -LogName $logName -Source $source
        } catch {
            Write-Warning "Unable to create Event Log source. Run PowerShell as Administrator."
        }
    }

    Write-EventLog -LogName $logName -Source $source -EntryType Information -EventId 2000 -Message $message
}

# Window setup
$window = New-Object System.Windows.Window
$window.Title = "Background & Personalization"
$window.ResizeMode = 'NoResize'
$window.WindowStartupLocation = 'CenterScreen'
$window.SizeToContent = 'WidthAndHeight'  # Auto-size to fit all content

# Layout panel
$stackPanel = New-Object System.Windows.Controls.StackPanel
$stackPanel.HorizontalAlignment = "Center"
$stackPanel.VerticalAlignment = "Center"
$window.Content = $stackPanel

# Header
$header = New-Object System.Windows.Controls.TextBlock
$header.Text = "Windows Personalization Tools"
$header.FontSize = 16
$header.FontWeight = "Bold"
$header.TextAlignment = "Center"
$header.Margin = "0,0,0,20"
$stackPanel.Children.Add($header)

# Define reusable margin and width for buttons
$buttonWidth = 320
$buttonMargin = [System.Windows.Thickness]::new(10)

# Button: Background
$btnBackground = New-Object System.Windows.Controls.Button
$btnBackground.Content = "Background Settings"
$btnBackground.Width = $buttonWidth
$btnBackground.Margin = $buttonMargin
$btnBackground.Add_Click({
    Start-Process "ms-settings:personalization-background"
    Log-Action "Opened Background settings"
})
$stackPanel.Children.Add($btnBackground)

# Button: Lock Screen
$btnLockScreen = New-Object System.Windows.Controls.Button
$btnLockScreen.Content = "Lock Screen Settings"
$btnLockScreen.Width = $buttonWidth
$btnLockScreen.Margin = $buttonMargin
$btnLockScreen.Add_Click({
    Start-Process "ms-settings:lockscreen"
    Log-Action "Opened Lock Screen settings"
})
$stackPanel.Children.Add($btnLockScreen)

# Button: Colors
$btnColors = New-Object System.Windows.Controls.Button
$btnColors.Content = "Colors"
$btnColors.Width = $buttonWidth
$btnColors.Margin = $buttonMargin
$btnColors.Add_Click({
    Start-Process "ms-settings:colors"
    Log-Action "Opened Colors settings"
})
$stackPanel.Children.Add($btnColors)

# Button: Themes
$btnThemes = New-Object System.Windows.Controls.Button
$btnThemes.Content = "Themes"
$btnThemes.Width = $buttonWidth
$btnThemes.Margin = $buttonMargin
$btnThemes.Add_Click({
    Start-Process "ms-settings:themes"
    Log-Action "Opened Themes settings"
})
$stackPanel.Children.Add($btnThemes)

# Button: Contrast Themes
$btnContrast = New-Object System.Windows.Controls.Button
$btnContrast.Content = "Contrast Themes"
$btnContrast.Width = $buttonWidth
$btnContrast.Margin = $buttonMargin
$btnContrast.Add_Click({
    Start-Process "ms-settings:easeofaccess-contrastthemes"
    Log-Action "Opened Contrast Themes settings"
})
$stackPanel.Children.Add($btnContrast)

# Button: Fonts
$btnFonts = New-Object System.Windows.Controls.Button
$btnFonts.Content = "Fonts"
$btnFonts.Width = $buttonWidth
$btnFonts.Margin = $buttonMargin
$btnFonts.Add_Click({
    Start-Process "ms-settings:fonts"
    Log-Action "Opened Fonts settings"
})
$stackPanel.Children.Add($btnFonts)

# Button: Start Menu
$btnStartMenu = New-Object System.Windows.Controls.Button
$btnStartMenu.Content = "Start Menu Settings"
$btnStartMenu.Width = $buttonWidth
$btnStartMenu.Margin = $buttonMargin
$btnStartMenu.Add_Click({
    Start-Process "ms-settings:personalization-start"
    Log-Action "Opened Start Menu settings"
})
$stackPanel.Children.Add($btnStartMenu)

# Button: Taskbar
$btnTaskbar = New-Object System.Windows.Controls.Button
$btnTaskbar.Content = "Taskbar Settings"
$btnTaskbar.Width = $buttonWidth
$btnTaskbar.Margin = $buttonMargin
$btnTaskbar.Add_Click({
    Start-Process "ms-settings:taskbar"
    Log-Action "Opened Taskbar settings"
})
$stackPanel.Children.Add($btnTaskbar)

# Footer
$footer = New-Object System.Windows.Controls.TextBlock
$footer.Text = "Allester Padovani - Senior IT Specialist"
$footer.FontSize = 12
$footer.FontStyle = [System.Windows.FontStyles]::Italic
$footer.Margin = "0,20,0,10"
$footer.HorizontalAlignment = "Center"
$stackPanel.Children.Add($footer)

# Show Window
$window.ShowDialog()
