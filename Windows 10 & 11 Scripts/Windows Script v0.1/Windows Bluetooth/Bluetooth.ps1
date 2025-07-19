<#
.SYNOPSIS
    WPF GUI launcher for all Bluetooth-related settings in Windows 11 24H2.

.DESCRIPTION
    Opens Bluetooth, device pairing, file transfer, airplane mode, and nearby sharing settings.
    Each setting is launched via its own button. Event log entries are written silently.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-15
    Version     : 1.0

.NOTES
    Compatibility: Windows 11 24H2
    Requires Admin for initial event source creation
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Add-Type -AssemblyName PresentationFramework

function Log-Action {
    param([string]$message)

    $logName = "Application"
    $source = "PowerShell - Bluetooth Launcher"

    if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
        try {
            New-EventLog -LogName $logName -Source $source
        } catch {
            Write-Warning "Unable to create Event Log source. Run PowerShell as Administrator."
        }
    }

    Write-EventLog -LogName $logName -Source $source -EntryType Information -EventId 3000 -Message $message
}

# Window setup
$window = New-Object System.Windows.Window
$window.Title = "Bluetooth Tools"
$window.Width = 420
$window.Height = 500
$window.ResizeMode = 'NoResize'
$window.WindowStartupLocation = 'CenterScreen'

# Layout
$stackPanel = New-Object System.Windows.Controls.StackPanel
$stackPanel.HorizontalAlignment = "Center"
$stackPanel.VerticalAlignment = "Center"
$window.Content = $stackPanel

# Header
$header = New-Object System.Windows.Controls.TextBlock
$header.Text = "Windows Bluetooth Tools"
$header.FontSize = 16
$header.FontWeight = "Bold"
$header.TextAlignment = "Center"
$header.Margin = "0,0,0,20"
$stackPanel.Children.Add($header)

# Button: Open Bluetooth Main Settings
$btnBluetooth = New-Object System.Windows.Controls.Button
$btnBluetooth.Content = "Bluetooth Settings"
$btnBluetooth.Width = 360
$btnBluetooth.Margin = [System.Windows.Thickness]::new(10)
$btnBluetooth.Add_Click({
    Start-Process "ms-settings:bluetooth"
    Log-Action "Opened Bluetooth Settings"
})
$stackPanel.Children.Add($btnBluetooth)

# Button: Device Pairing (Discover Devices)
$btnPairing = New-Object System.Windows.Controls.Button
$btnPairing.Content = "Pair New Devices"
$btnPairing.Width = 360
$btnPairing.Margin = [System.Windows.Thickness]::new(10)
$btnPairing.Add_Click({
    Start-Process "ms-settings:connecteddevices"
    Log-Action "Opened Device Pairing Settings"
})
$stackPanel.Children.Add($btnPairing)

# Button: Bluetooth File Transfer (via Explorer)
$btnFileTransfer = New-Object System.Windows.Controls.Button
$btnFileTransfer.Content = "Bluetooth File Transfer"
$btnFileTransfer.Width = 360
$btnFileTransfer.Margin = [System.Windows.Thickness]::new(10)
$btnFileTransfer.Add_Click({
    Start-Process "fsquirt.exe"
    Log-Action "Opened Bluetooth File Transfer Wizard"
})
$stackPanel.Children.Add($btnFileTransfer)

# Button: Airplane Mode
$btnAirplane = New-Object System.Windows.Controls.Button
$btnAirplane.Content = "Airplane Mode Settings"
$btnAirplane.Width = 360
$btnAirplane.Margin = [System.Windows.Thickness]::new(10)
$btnAirplane.Add_Click({
    Start-Process "ms-settings:network-airplanemode"
    Log-Action "Opened Airplane Mode Settings"
})
$stackPanel.Children.Add($btnAirplane)

# Button: Nearby Sharing
$btnNearbySharing = New-Object System.Windows.Controls.Button
$btnNearbySharing.Content = "Nearby Sharing"
$btnNearbySharing.Width = 360
$btnNearbySharing.Margin = [System.Windows.Thickness]::new(10)
$btnNearbySharing.Add_Click({
    Start-Process "ms-settings:crossdevice"
    Log-Action "Opened Nearby Sharing Settings"
})
$stackPanel.Children.Add($btnNearbySharing)

# Footer
$footer = New-Object System.Windows.Controls.TextBlock
$footer.Text = "Allester Padovani - Senior IT Specialist"
$footer.FontSize = 12
$footer.FontStyle = [System.Windows.FontStyles]::Italic
$footer.Margin = "0,20,0,10"
$footer.HorizontalAlignment = "Center"
$stackPanel.Children.Add($footer)

# Show window
$window.ShowDialog()
