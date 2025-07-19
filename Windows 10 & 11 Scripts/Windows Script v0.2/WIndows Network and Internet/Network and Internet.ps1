<#
.SYNOPSIS
    WPF GUI with two columns of buttons for Network & Internet settings on Windows 11.

.DESCRIPTION
    Each button opens a specific network-related Windows 11 settings URI.
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
$window.Title = "Network & Internet Settings"
$window.ResizeMode = [System.Windows.ResizeMode]::NoResize
$window.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterScreen
$window.SizeToContent = 'WidthAndHeight'  # Auto-size to fit all content

# Main vertical stack panel
$mainStack = New-Object System.Windows.Controls.StackPanel
$mainStack.Orientation = [System.Windows.Controls.Orientation]::Vertical
$mainStack.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$mainStack.VerticalAlignment = [System.Windows.VerticalAlignment]::Center
$window.Content = $mainStack

# Header text block
$header = New-Object System.Windows.Controls.TextBlock
$header.Text = "Network & Internet Settings"
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

# Define buttons - LEFT COLUMN
$buttonsLeft = @(
    @{ Label = "Network & Internet"; Uri = "ms-settings:network-status" },
    @{ Label = "Advanced Settings"; Uri = "ms-settings:network-advancedsettings" },
    @{ Label = "Airplane Mode"; Uri = "ms-settings:network-airplanemode" },
    @{ Label = "Proximity"; Uri = "ms-settings:proximity" },
    @{ Label = "Cellular & SIM"; Uri = "ms-settings:network-cellular" },
    @{ Label = "Dial-up"; Uri = "ms-settings:network-dialup" },
    @{ Label = "DirectAccess"; Uri = "ms-settings:network-directaccess" }
)

foreach ($item in $buttonsLeft) {
    $btn = New-Object System.Windows.Controls.Button
    $btn.Content = $item.Label
    $btn.Width = 330
    $btn.Margin = [System.Windows.Thickness]::new(10)
    $btn.Add_Click({
        Start-Process $item.Uri
        Log-Action "Opened $($item.Label) settings"
    })
    $leftColumn.Children.Add($btn)
}

# Define buttons - RIGHT COLUMN
$buttonsRight = @(
    @{ Label = "Ethernet"; Uri = "ms-settings:network-ethernet" },
    @{ Label = "Manage Known Networks"; Uri = "ms-settings:network-wifisettings" },
    @{ Label = "Mobile Hotspot"; Uri = "ms-settings:network-mobilehotspot" },
    @{ Label = "Proxy"; Uri = "ms-settings:network-proxy" },
    @{ Label = "VPN"; Uri = "ms-settings:network-vpn" },
    @{ Label = "Wi-Fi"; Uri = "ms-settings:network-wifi" },
    @{ Label = "Wi-Fi Provisioning"; Uri = "ms-settings:wifi-provisioning" }
)

foreach ($item in $buttonsRight) {
    $btn = New-Object System.Windows.Controls.Button
    $btn.Content = $item.Label
    $btn.Width = 330
    $btn.Margin = [System.Windows.Thickness]::new(10)
    $btn.Add_Click({
        Start-Process $item.Uri
        Log-Action "Opened $($item.Label) settings"
    })
    $rightColumn.Children.Add($btn)
}

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
