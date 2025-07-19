<#
.SYNOPSIS
    WPF GUI to launch all color-related personalization settings in Windows 11 24H2.

.DESCRIPTION
    Creates a GUI with buttons to open various Color settings pages, such as accent color, transparency, dark/light mode, etc.
    Each action is logged to the Windows Application event log for auditing purposes.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-16
    Version     : 1.0

.NOTES
    Compatibility: Windows 11 24H2 and later
    Requires    : Admin rights to register event log source (first run)
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Add-Type -AssemblyName PresentationFramework

function Log-Action {
    param([string]$message)

    $logName = "Application"
    $source = "PowerShell - Colors Settings"

    if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
        try {
            New-EventLog -LogName $logName -Source $source
        } catch {
            Write-Warning "Could not create event log source. Run PowerShell as Administrator."
        }
    }

    Write-EventLog -LogName $logName -Source $source -EntryType Information -EventId 4200 -Message $message
}

# Main window setup
$window = New-Object System.Windows.Window
$window.Title = "Colors Settings – Windows 11"
# Let window size itself based on content
$window.SizeToContent = 'WidthAndHeight'
$window.ResizeMode = 'NoResize'
$window.WindowStartupLocation = 'CenterScreen'

$panel = New-Object System.Windows.Controls.StackPanel
$panel.HorizontalAlignment = "Center"
$panel.VerticalAlignment = "Center"
$window.Content = $panel

# Header
$header = New-Object System.Windows.Controls.TextBlock
$header.Text = "Color Personalization Tools"
$header.FontSize = 16
$header.FontWeight = "Bold"
$header.TextAlignment = "Center"
$header.Margin = "0,0,0,20"
$panel.Children.Add($header)

# Button: Colors Settings
$btnColors = New-Object System.Windows.Controls.Button
$btnColors.Content = "Accent Colors & Themes"
$btnColors.Width = 320
$btnColors.Margin = [System.Windows.Thickness]::new(10)
$btnColors.Add_Click({
    Start-Process "ms-settings:personalization-colors"
    Log-Action "Opened Accent Colors & Themes"
})
$panel.Children.Add($btnColors)

# Button: Transparency Effects
$btnTransparency = New-Object System.Windows.Controls.Button
$btnTransparency.Content = "Transparency Effects"
$btnTransparency.Width = 320
$btnTransparency.Margin = [System.Windows.Thickness]::new(10)
$btnTransparency.Add_Click({
    Start-Process "ms-settings:personalization-colors"
    Log-Action "Opened Transparency Effects in Color Settings"
})
$panel.Children.Add($btnTransparency)

# Button: Dark/Light Mode
$btnThemeMode = New-Object System.Windows.Controls.Button
$btnThemeMode.Content = "Dark / Light Mode"
$btnThemeMode.Width = 320
$btnThemeMode.Margin = [System.Windows.Thickness]::new(10)
$btnThemeMode.Add_Click({
    Start-Process "ms-settings:personalization-colors"
    Log-Action "Accessed Theme Mode (Dark/Light) Settings"
})
$panel.Children.Add($btnThemeMode)

# Button: Themes Page (related to color schemes)
$btnThemes = New-Object System.Windows.Controls.Button
$btnThemes.Content = "Manage Themes"
$btnThemes.Width = 320
$btnThemes.Margin = [System.Windows.Thickness]::new(10)
$btnThemes.Add_Click({
    Start-Process "ms-settings:themes"
    Log-Action "Opened Themes Page"
})
$panel.Children.Add($btnThemes)

# Footer
$footer = New-Object System.Windows.Controls.TextBlock
$footer.Text = "Allester Padovani – Senior IT Specialist"
$footer.FontSize = 12
$footer.FontStyle = [System.Windows.FontStyles]::Italic
$footer.Margin = "0,20,0,10"
$footer.HorizontalAlignment = "Center"
$panel.Children.Add($footer)

# Show the GUI
$window.ShowDialog()
